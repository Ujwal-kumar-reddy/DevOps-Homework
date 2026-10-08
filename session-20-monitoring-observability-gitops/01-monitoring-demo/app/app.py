from flask import Flask, jsonify, request, Response
import time
import os
import psutil
from prometheus_client import Counter, Histogram, Gauge, generate_latest, CONTENT_TYPE_LATEST

app = Flask(__name__)

# Prometheus Metrics Definitions
REQUEST_COUNT = Counter(
    "http_requests_total",
    "Total HTTP Requests",
    ["method", "endpoint", "status"]
)
REQUEST_LATENCY = Histogram(
    "http_request_duration_seconds",
    "HTTP Request Latency in Seconds",
    ["endpoint"]
)
ACTIVE_CONNECTIONS = Gauge(
    "app_active_connections",
    "Current active connections being processed"
)
SYSTEM_CPU_USAGE = Gauge(
    "process_cpu_usage_percent",
    "Current CPU utilization percent of application process"
)
SYSTEM_MEM_USAGE = Gauge(
    "process_memory_usage_bytes",
    "Current Memory Resident Set Size (RSS) in bytes"
)

@app.route("/")
def home():
    ACTIVE_CONNECTIONS.inc()
    start_time = time.time()
    try:
        REQUEST_COUNT.labels(method="GET", endpoint="/", status="200").inc()
        return jsonify({
            "message": "⚡ Monitoring & Observability Service Active",
            "session": "Session 20",
            "status": "healthy"
        })
    finally:
        REQUEST_LATENCY.labels(endpoint="/").observe(time.time() - start_time)
        ACTIVE_CONNECTIONS.dec()

@app.route("/health")
def health():
    REQUEST_COUNT.labels(method="GET", endpoint="/health", status="200").inc()
    return jsonify({
        "status": "healthy",
        "timestamp": time.time(),
        "cpu_percent": psutil.cpu_percent(),
        "memory_percent": psutil.virtual_memory().percent
    })

@app.route("/metrics")
def metrics():
    # Update system utilization gauges
    SYSTEM_CPU_USAGE.set(psutil.cpu_percent())
    SYSTEM_MEM_USAGE.set(psutil.Process(os.getpid()).memory_info().rss)
    return Response(generate_latest(), mimetype=CONTENT_TYPE_LATEST)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
