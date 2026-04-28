FROM python:3.13-slim

WORKDIR /app

COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

COPY arc /app/src
COPY migrations /app/migrations

ENV PYTHONPATHH=/app/src

EXPOSE 8000
