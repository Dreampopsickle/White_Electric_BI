from google.cloud import bigquery
from google.api_core.exceptions import NotFound 
import os
import logging
import csv
import glob
import pandas as pd

# Configure Logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

CREATED_AT_COLUMN = "created_at"

def upload_csv_to_bigquery(file_path, table_id):
    """Upload a CSV file to a BigQuery raw staging table.
    
    All columns are loaded as STRING except the hardcoded TIMESTAMP column.
    The table is partitioned on the TIMESTAMP column if it exists; otherwise,
    ingestion time partitioning is used.
    """
    # Initialize BQ client
    client = bigquery.Client()

    #Read only header to build schema
    df = pd.read_csv(file_path, nrows=0)
    columns = df.columns.tolist()

    #Build schema: CREATED_AT_COLUMN is TIMESTAMP, all others are STRING
    schema = []
    for col in columns:
        if col == CREATED_AT_COLUMN:
            schema.append(bigquery.SchemaField(col, "TIMESTAMP"))
        else: 
            schema.append(bigquery.SchemaField(col, "STRING"))

    # Check if table exists; if not, create it with our defined schema and partitioning        
    try: 
        client.get_table(table_id)
        logger.info(f"Table {table_id} already exists. Proceeding with data append.")
    except NotFound:
        logger.info(
            f"Table {table_id} does not exist. Creating table with schema."
            f"{[f'{field.name}:{field.field_type}' for field in schema]}."        
        )
        try: 
            table = bigquery.Table(table_id, schema=schema)
             # Configure partitioning: partition on TIMESTAMP_COLUMN if it exists; else, use ingestion time.
            if CREATED_AT_COLUMN in columns:
                table.time_partitioning = bigquery.TimePartitioning(
                    type_=bigquery.TimePartitioningType.DAY,
                    field=CREATED_AT_COLUMN # partition using created_at column
                )
                logger.info(f"Partitioning table {table_id} on column '{CREATED_AT_COLUMN}'.")
            else:
                table.time_partitioning = bigquery.TimePartitioning(
                    type_=bigquery.TimePartitioningType.DAY,
                    field=None # Use ingestion time for partitioning
                )
                logger.info(f"Partitioning table {table_id} on ingestion time.")
            client.create_table(table)
            logger.info(f"Table {table_id} created successfully.")
        except Exception as e:
            logger.error(f"Failed to create table {table_id}: {e}")
            return
    # Load job config
    # write_disposition = os.getenv("WRITE_DISPOSITION", bigquery.WriteDisposition.WRITE_APPEND)
    # max_bad_records = int(os.getenv("MAX_BAD_RECORDS", "10"))

    # Define job config
    job_config = bigquery.LoadJobConfig(
        source_format=bigquery.SourceFormat.CSV,
        skip_leading_rows=1,
        schema=schema,
        autodetect=False,
        write_disposition=bigquery.WriteDisposition.WRITE_APPEND, # Append data to existing table
        ignore_unknown_values=True, # Allow extra columns in CSV
        max_bad_records=10
    )

    #Load CSV in BQ
    try:
        with open(file_path, "rb") as file:
            job = client.load_table_from_file(file, table_id, job_config=job_config)
            job.result()
            logger.info(f"Loaded {job.output_rows} rows into {table_id}.")
    except Exception as e: 
        logger.error(f"Error uploading file {file_path} to {table_id}: {e}")
        if job.errors:
            for error in job.errors:
                logger.error(error)

    # Delete csv after successful upload
    try:
        os.remove(file_path)
        logger.info(f"Delete File: {file_path}")
    except Exception as e:
        logger.error(f"Failed to delete file {file_path}: {e}")

if __name__ == "__main__":
    #Env var
    dataset_id = os.getenv("BIGQUERY_DATASET")
    project_id = os.getenv("BIGQUERY_PROJECT_ID")

    if not dataset_id or not project_id:
        raise ValueError("BIGQUERY_DATASET and BIGQUERY_PROJECT_ID must be set.")
    data_dir = "./data/"
    file_paths = glob.glob(f"{data_dir}/*.csv")
    if not file_paths:
        logger.warning("No CSV files found in the data directory.")

    for file_path in file_paths:
        table_name = os.path.splitext(os.path.basename(file_path))[0]
        table_id = f"{project_id}.{dataset_id}.{table_name}"
        upload_csv_to_bigquery(file_path, table_id)
        