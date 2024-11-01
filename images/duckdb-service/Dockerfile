FROM python:3.9-slim-buster

WORKDIR /app
RUN apt-get update \
      && apt-get install -y --no-install-recommends \
      --no-install-suggests build-essential \
      && pip install --no-cache-dir --upgrade pip

RUN pip install --no-cache-dir duckdb boto3 fastapi pydantic uvicorn fsspec

COPY . /app

EXPOSE 8003

CMD ["python", "src/main.py"]