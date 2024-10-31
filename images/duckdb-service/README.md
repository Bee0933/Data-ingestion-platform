## duckdb-query-service

This custom service acts as a tool for querying platform data from the MinIO S3 data lake source. It operates a FastAPI server configured with the `DUCKDB_SERVER_PORT` variable.

### Building the image

```bash
docker buildx build -t <name>:<tag> .
```

### Running the duckdb-query-service

```bash
docker run bestnyah/duckdb-query-service:latest
```

#### Variables (all required)

```bash
# Details required to run the container
    MINIO_ACCESS_KEY=
    MINIO_SECRET_KEY=
    MINIO_ENDPOINT_URL=
    MINIO_BUCKET_NAME=
    DUCKDB_SERVER_PORT=


