from google.cloud import bigquery
import os
import logging

# Configure Logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def upload_csv_to_bigquery(file_path, table_id, schema):
    # Initialize BQ client
    client = bigquery.Client()

    # Define job config
    job_config = bigquery.LoadJobConfig(
        source_format=bigquery.SourceFormat.CSV,
        skip_leading_rows=1,
        autodetect=schema is None, # use schema, else autodetect
        schema=schema,
    )

    #Load CSV in BQ
    with open(file_path, "rb") as file:
        job = client.load_table_from_file(file, table_id, job_config=job_config)
        job.result() #wait for job to complete

    logger.info(f"Loaded {job.output_rows} rows into {table_id}.")

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
    file_paths = [
        "./data/payment_data.csv",
        "./data/orders_data.csv",
        "./data/line_items_data.csv"
    ]

    tables = ["payments", "orders", "line_items"]

    for file_path, table_name in zip(file_paths, tables):
        table_id = f"{project_id}.{dataset_id}.{table_name}"
        upload_csv_to_bigquery(file_path, table_id, schema=None)