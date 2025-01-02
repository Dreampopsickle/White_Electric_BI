from google.cloud import bigquery
from google.api_core.exceptions import NotFound 
import os
import logging

# Configure Logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def upload_csv_to_bigquery(file_path, table_id, schema, partition_column=None):
    # Initialize BQ client
    client = bigquery.Client()

    # Check if table exists
    try: 
        table = client.get_table(table_id)
        logger.info(f"Table {table_id} already exists.")
    except NotFound:
        # Create table with partitioning if it doesn't exist
        if not schema:
            raise ValueError("Schema must be provided for creating partitioned tables")
        table = bigquery.Table(table_id, schema=schema)

        if partition_column:
            table.time_partitioning = bigquery.TimePartitioning(
                field=partition_column, #Specifiy partition column
                type_=bigquery.TimePartitioningType.DAY # Partition by Day
            )
            logger.info(f"Creating partition table {table_id} on column {partition_column}. ")
        table = client.create_table(table) # API request to create table
        logger.info(f"Table {table_id} created. ")

    # Define job config
    job_config = bigquery.LoadJobConfig(
        source_format=bigquery.SourceFormat.CSV,
        skip_leading_rows=1,
        autodetect=False, # Autodetect disabled for partitioned tables
        schema=schema,
        write_disposition=bigquery.WriteDisposition.WRITE_APPEND, # Append data to existing table
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

    tables = [
        {"name": "payments", 
         "schema": [
            bigquery.SchemaField("id", "STRING", mode="NULLABLE"),
            bigquery.SchemaField("created_at", "TIMESTAMP", mode="NULLABLE"),
            bigquery.SchemaField("updated_at", "TIMESTAMP", mode="NULLABLE"),
            bigquery.SchemaField("amount_money", "STRING", mode="NULLABLE"),
            bigquery.SchemaField("status", "STRING", mode="NULLABLE"),
            bigquery.SchemaField("source_type", "STRING", mode="NULLABLE"),
            bigquery.SchemaField("location_id", "STRING", mode="NULLABLE"),
            bigquery.SchemaField("order_id", "STRING", mode="NULLABLE"),
            bigquery.SchemaField("total_money", "STRING", mode="NULLABLE"),
            bigquery.SchemaField("employee_id", "STRING", mode="NULLABLE"),
            bigquery.SchemaField("cash_details", "STRING", mode="NULLABLE"),
            bigquery.SchemaField("receipt_number", "STRING", mode="NULLABLE"),
            bigquery.SchemaField("receipt_url", "STRING", mode="NULLABLE"),
            bigquery.SchemaField("device_details", "STRING", mode="NULLABLE"),
            bigquery.SchemaField("team_member_id", "STRING", mode="NULLABLE"),
            bigquery.SchemaField("application_details", "STRING", mode="NULLABLE"),
            bigquery.SchemaField("version_token", "STRING", mode="NULLABLE"),
            bigquery.SchemaField("tip_money", "STRING", mode="NULLABLE"),
            bigquery.SchemaField("card_details", "STRING", mode="NULLABLE"),
            bigquery.SchemaField("processing_fee", "STRING", mode="NULLABLE"),
            bigquery.SchemaField("customer_id", "STRING", mode="NULLABLE"),
            bigquery.SchemaField("approved_money", "STRING", mode="NULLABLE"),
            bigquery.SchemaField("delay_duration", "STRING", mode="NULLABLE"),
            bigquery.SchemaField("reference_id", "FLOAT", mode="NULLABLE"),
            bigquery.SchemaField("risk_evaluation", "STRING", mode="NULLABLE"),
            bigquery.SchemaField("buyer_email_address", "STRING", mode="NULLABLE"),
            bigquery.SchemaField("billing_address", "STRING", mode="NULLABLE"),
            bigquery.SchemaField("shipping_address", "STRING", mode="NULLABLE"),
            bigquery.SchemaField("delay_action", "STRING", mode="NULLABLE"),
            bigquery.SchemaField("delayed_until", "STRING", mode="NULLABLE"),
            bigquery.SchemaField("external_details", "STRING", mode="NULLABLE"),
         ],
         "partition_column": "created_at"
         }, #has timestamp
        
        {"name": "orders", 
         "schema": [
            bigquery.SchemaField("order_id", "STRING", mode="NULLABLE"),
            bigquery.SchemaField("location_id", "STRING", mode="NULLABLE"),
            bigquery.SchemaField("created_at", "TIMESTAMP", mode="NULLABLE"),
            bigquery.SchemaField("updated_at", "TIMESTAMP", mode="NULLABLE"),
            bigquery.SchemaField("state", "STRING", mode="NULLABLE"),
            bigquery.SchemaField("total_money", "FLOAT", mode="NULLABLE"),
            bigquery.SchemaField("total_tax_money", "FLOAT", mode="NULLABLE"),
            bigquery.SchemaField("total_tip_money", "FLOAT", mode="NULLABLE"),
            bigquery.SchemaField("total_discount_money", "FLOAT", mode="NULLABLE"),
            bigquery.SchemaField("total_service_charge_money", "FLOAT", mode="NULLABLE"),
         ],
         "partition_column": "created_at"}, #has timestamp
        
        {"name": "line_items", 
         "schema": [
            bigquery.SchemaField("order_id", "STRING", mode="NULLABLE"),
            bigquery.SchemaField("line_item_uid", "STRING", mode="NULLABLE"),
            bigquery.SchemaField("item_name", "STRING", mode="NULLABLE"),
            bigquery.SchemaField("quantity", "FLOAT", mode="NULLABLE"),
            bigquery.SchemaField("base_price", "FLOAT", mode="NULLABLE"),
            bigquery.SchemaField("gross_sales", "FLOAT", mode="NULLABLE"),
            bigquery.SchemaField("total_money", "FLOAT", mode="NULLABLE"),
            bigquery.SchemaField("modifier_name", "STRING", mode="NULLABLE"),
            bigquery.SchemaField("modifier_price", "FLOAT", mode="NULLABLE")
         ],
         "partition_column": None} #no timestamp
    ]

    for file_path, table in zip(file_paths, tables):
        table_id = f"{project_id}.{dataset_id}.{table['name']}"

        #Only pass partition_colummn if it's defined
        if table["partition_column"]: 
            upload_csv_to_bigquery(
                file_path=file_path,
                table_id=table_id,
                schema=table["schema"],
                partition_column=table["partition_column"]
            )
        else:
            #skip partitioning for tables without partition column
            upload_csv_to_bigquery(
                file_path=file_path,
                table_id=table_id,
                schema=table["schema"],
                partition_column=None
            )
        