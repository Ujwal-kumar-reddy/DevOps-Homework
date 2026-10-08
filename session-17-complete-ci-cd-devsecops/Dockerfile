# Multi-stage / secure production Dockerfile
FROM python:3.12-slim

WORKDIR /app

# Create a non-root user for DevSecOps best practices
RUN groupadd -r appuser && useradd -r -g appuser appuser

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY app ./app

RUN chown -R appuser:appuser /app

USER appuser

EXPOSE 5001

ENV PYTHONUNBUFFERED=1

CMD ["python", "app/app.py"]
