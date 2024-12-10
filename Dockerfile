# Use an official Python image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Install dbt
RUN pip install dbt-core dbt-bigquery

# Ensure environment variables are loaded
ENV GOOGLE_APPLICATION_CREDENTIALS=/app/we-service-account.json
ENV DBT_PROFILES_DIR=/app/.dbt

# Copy application files
COPY . .

# Copy service account credentials (ensure it exists locally)
COPY we-service-account.json /app/we-service-account.json

# Initialize dbt if needed
RUN dbt init my_project || true

# Default command
CMD ["bash", "-c", "python scripts/fetch_orders.py && python scripts/upload_to_bigquery.py"]