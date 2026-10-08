import pytest
from app.app import app

@pytest.fixture
def client():
    app.config["TESTING"] = True
    with app.test_client() as client:
        yield client

# Test 1: Home page loads
def test_home(client):
    response = client.get("/")
    assert response.status_code == 200

# Test 2: Health check returns healthy
def test_health(client):
    response = client.get("/health")
    assert response.status_code == 200
    data = response.get_json()
    assert data["status"] == "healthy"
    assert "uptime_seconds" in data

# Test 3: Status API returns system info
def test_status(client):
    response = client.get("/api/status")
    assert response.status_code == 200
    data = response.get_json()
    assert data["status"] == "running"
    assert "python_version" in data
    assert "uptime" in data

# Test 4: Greet endpoint returns greeting
def test_greet(client):
    response = client.get("/api/greet/DevSecOpsHero")
    assert response.status_code == 200
    data = response.get_json()
    assert "DevSecOpsHero" in data["message"]

# Test 5: Add API returns addition result
def test_add_numbers(client):
    response = client.post("/api/add", json={"number1": 15, "number2": 35})
    assert response.status_code == 200
    data = response.get_json()
    assert data["result"] == 50

# Test 6: Add API validates missing input
def test_add_numbers_missing_input(client):
    response = client.post("/api/add", json={"number1": 10})
    assert response.status_code == 400

# Test 7: Calculator API performs multiplication
def test_calculator_multiply(client):
    response = client.post("/api/calculate", json={"a": 7, "b": 6, "operation": "multiply"})
    assert response.status_code == 200
    data = response.get_json()
    assert data["result"] == 42

# Test 8: Calculator handles division by zero safely
def test_calculator_divide_by_zero(client):
    response = client.post("/api/calculate", json={"a": 25, "b": 0, "operation": "divide"})
    assert response.status_code == 400
    data = response.get_json()
    assert "error" in data

# Test 9: Pipeline simulation executes all stages
def test_pipeline_simulation(client):
    response = client.post("/api/pipeline/run", json={"branch": "main", "fail_chance": 0.0})
    assert response.status_code == 200
    data = response.get_json()
    assert data["overall_status"] == "passed"
    assert len(data["stages"]) == 10
