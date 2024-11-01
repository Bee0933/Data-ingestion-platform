import json, os, duckdb, boto3, logging, uvicorn, tempfile
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field
from typing import List


# Logging config
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    handlers=[logging.StreamHandler()],
)

MINIO_ACCESS_KEY = os.getenv('MINIO_ACCESS_KEY')
MINIO_SECRET_KEY = os.getenv('MINIO_SECRET_KEY')
MINIO_ENDPOINT_URL = os.getenv('MINIO_ENDPOINT_URL')
MINIO_BUCKET_NAME = os.getenv('MINIO_BUCKET_NAME')
DUCKDB_SERVER_PORT = os.getenv('DUCKDB_SERVER_PORT')

# Initialize FastAPI app
app = FastAPI()

# Initialize DuckDB connection
db = duckdb.connect(database=':memory:')  # In-memory DuckDB instance

# Initialize MinIO client
s3_client = boto3.client(
    's3',
    endpoint_url=MINIO_ENDPOINT_URL,
    aws_access_key_id=MINIO_ACCESS_KEY,
    aws_secret_access_key=MINIO_SECRET_KEY
)

# Request model for SQL query with default values
class QueryRequest(BaseModel):
    file_name: str = Field(default="your/filepath.csv", description="The name of the CSV file to query.")
    query: str = Field(default="SELECT * FROM my_table", description="The SQL query to execute.")

@app.get("/list-files", response_model=List[str])
async def list_files():
    """
    Lists CSV files in the MinIO bucket.
    """
    try:
        objects = s3_client.list_objects_v2(Bucket=MINIO_BUCKET_NAME)
        files = [obj['Key'] for obj in objects.get('Contents', []) if obj['Key'].endswith('.csv')]
        logging.info("extracted csv filepaths")
        return files
    except Exception as e:
        logging.info(e)
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/query")
async def query_duckdb(request: QueryRequest):
    """
    Accepts file name and SQL query to execute using DuckDB, returning the results in JSON.
    The SQL queries target CSV files stored in MinIO.
    """
    file_name = request.file_name
    sql_query = request.query
    
    try:
        # Fetch the CSV file from MinIO
        response = s3_client.get_object(Bucket=MINIO_BUCKET_NAME, Key=file_name)
        csv_content = response['Body'].read().decode('utf-8')
        logging.info("fetched csv content!")

        # Write the CSV content to a temporary file
        with tempfile.NamedTemporaryFile(delete=False, suffix='.csv') as temp_file:
            temp_file.write(csv_content.encode('utf-8'))
            temp_file_path = temp_file.name  # Store the path of the temporary file
            logging.info(f"created temporary csv file from fetched content -> {temp_file_path}")

        # Create a temporary table from the CSV file
        db.execute(f"CREATE TABLE my_table AS SELECT * FROM read_csv_auto('{temp_file_path}')")
        logging.info("created temporary duckcb table from csv!")

        # Execute the query in DuckDB
        result = db.execute(sql_query).fetchall()
        logging.info("executed custom sql query!")

        column_names = [desc[0] for desc in db.description]

        # Extract and parse only the '_airbyte_data' field from each row
        airbyte_data_results = []
        for row in result:
            airbyte_data_str = row[column_names.index('_airbyte_data')]
            # Parse the JSON string to a Python dictionary
            airbyte_data_dict = json.loads(airbyte_data_str)
            airbyte_data_results.append({'_airbyte_data': airbyte_data_dict})
        logging.info("parsed _airbyte_data!")
        
        # Optional: Cleanup temporary file after the query execution
        os.remove(temp_file_path)  # Remove the temporary file after use
        logging.info(f"removed temporary csv file -> {temp_file_path}")
        
        return {"result": airbyte_data_results}
    except Exception as e:
        logging.info(e)
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=int(DUCKDB_SERVER_PORT))
