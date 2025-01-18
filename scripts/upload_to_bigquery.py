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

def infer_schema_from_csv(file_path):
    """Infer schema from CSV"""
    df = pd.read_csv(file_path, nrows=10) # Read onlyt the first 10 rows for inference
    inferred_schema = []
    
    for col, dtype in zip(df.columns, df.dtypes):
        if pd.api.types.is_integer_dtype(dtype):
            inferred_schema.append((col, "INTEGER"))
        elif pd.api.types.is_float_dtype(dtype):
            inferred_schema.append((col, "FLOAT"))
        elif pd.api.types.is_bool_dtype(dtype):
            inferred_schema.append((col, "BOOLEAN"))
        elif pd.api.types.is_datetime64_any_dtype(dtype):
            inferred_schema.append((col, "TIMESTAMP"))
        else:
            inferred_schema.append((col, "STRING"))
    return inferred_schema

def preprocess_csv(file_path):
    """Clean and preprocess the CSV file dynamically."""
    df = pd.read_csv(file_path)
    # Identify and flatten JSON_like columns
    for col in df.columns:
        if df[col].apply(lambda x: isinstance(x, (dict, list))).any():
            df[col] = df[col].astype(str)
    # save cleaned file back
    df.to_csv(file_path, index=False)

def sync_table_schema_with_csv(client, table_id, inferred_schema):
    """Sync BQ table schema with inferred schema"""
    try: 
        table = client.get_table(table_id)
        existing_fields = {field.name for field in table.schema}
        new_fields=  [
            bigquery.SchemaField(name, field_type)
            for name, field_type in inferred_schema
            if name not in existing_fields
        ]

        if new_fields:
            logger.info(f"Adding missing fields to table {table_id}: {[field.name for field in new_fields]}")
            table.schema += new_fields
            client.update_table(table, ["schema"])
    except Exception as e:
        logger.error(f"Error syncing schema for table {table_id}: {e}")

def upload_csv_to_bigquery(file_path, table_id):
    """ Upload a CSV file to a BigQuery table with schema autodetection."""
    # Initialize BQ client
    client = bigquery.Client()

    # infer schema from CSV
    # preprocess_csv(file_path)
    # inferred_schema = infer_schema_from_csv(file_path)

    # Check if table exists and get schema
    try: 
        client.get_table(table_id)
        logger.info(f"Table {table_id} already exists. Syncing schema.")
        # sync_table_schema_with_csv(client, table_id, inferred_schema)
    except NotFound:
        # Create table with partitioning if it doesn't exist
        logger.info(f"Table {table_id} does not exist. Creating it.")
        # schema = [bigquery.SchemaField(name, field_type) for name, field_type in inferred_schema]
        try: 
            table = bigquery.Table(table_id)
            client.create_table(table)
            logger.info(f"Table {table_id} created successfully.")
        except Exception as e:
            logger.error(f"Failed to create table {table_id}: {e}")
            return
    # Load job config
    write_disposition = os.getenv("WRITE_DISPOSITION", bigquery.WriteDisposition.WRITE_APPEND)
    max_bad_records = int(os.getenv("MAX_BAD_RECORDS", "10"))

    # Define job config
    job_config = bigquery.LoadJobConfig(
        source_format=bigquery.SourceFormat.CSV,
        skip_leading_rows=1,
        autodetect=True,
        write_disposition=write_disposition, # Append data to existing table
        ignore_unknown_values=True, # Allow extra columns in CSV
        max_bad_records=max_bad_records
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
        