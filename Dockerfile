# Use an official Python image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY . .

# Ensure environment variables are loaded
ENV GOOGLE_APPLICATION_CREDENTIALS=/app/we-service-account.json

# Initialize dbt if needed
RUN dbt init my_project || true

# Default command
CMD ["python", "scripts/fetch_orders.py"]