# API Documentation

## Focus Meditation Agent REST API

### Overview

The Focus Meditation Agent API provides endpoints for accessing meditation session data, retrieving statistics, and predicting meditation outcomes using machine learning. All responses are returned in JSON format.

**Base URL**: `http://localhost:5000` (local development)  
**Production URL**: Available via Docker container deployment  
**API Version**: 1.0

---

## Authentication

Currently, the API does not require authentication. All endpoints are publicly accessible.

---

## Endpoints

### 1. Health Check

**Endpoint**: `GET /`

**Description**: Basic health check to verify the API is running.

**Request**:
```http
GET / HTTP/1.1
Host: localhost:5000
```

**Response**:
```json
{
    "status": "ok",
    "msg": "Focus Meditation Agent"
}
```

**Response Codes**:
- `200 OK`: API is running normally

---

### 2. Detailed Health Status

**Endpoint**: `GET /health`

**Description**: Comprehensive health check providing system status, data availability, and model status.

**Request**:
```http
GET /health HTTP/1.1
Host: localhost:5000
```

**Response**:
```json
{
    "status": "healthy",
    "timestamp": "2025-09-20T12:00:00Z",
    "data_loaded": true,
    "model_loaded": true,
    "version": "1.0.0"
}
```

**Response Fields**:
- `status`: Overall system status (`healthy` | `unhealthy`)
- `timestamp`: Current server timestamp in ISO 8601 format
- `data_loaded`: Boolean indicating if dataset is loaded successfully
- `model_loaded`: Boolean indicating if ML model is loaded successfully
- `version`: Current API version

**Response Codes**:
- `200 OK`: System is healthy
- `503 Service Unavailable`: System issues detected

---

### 3. Meditation Sessions

**Endpoint**: `GET /sessions`

**Description**: Retrieve all meditation session records from the dataset.

**Request**:
```http
GET /sessions HTTP/1.1
Host: localhost:5000
```

**Response**:
```json
[
    {
        "date": "2025-09-01",
        "duration_minutes": 15,
        "mood_before": "stressed",
        "mood_after": "calm"
    },
    {
        "date": "2025-09-02",
        "duration_minutes": 20,
        "mood_before": "neutral",
        "mood_after": "relaxed"
    }
]
```

**Response Fields**:
- `date`: Session date in YYYY-MM-DD format
- `duration_minutes`: Session length in minutes (integer)
- `mood_before`: Initial mood state (string)
- `mood_after`: Post-meditation mood state (string)

**Response Codes**:
- `200 OK`: Sessions retrieved successfully
- `200 OK` with empty array `[]`: No sessions available

**Possible Values**:
- `mood_before`: `"stressed"`, `"neutral"`, `"anxious"`, `"tired"`
- `mood_after`: `"calm"`, `"relaxed"`, `"focused"`, `"energized"`

---

### 4. Session Statistics

**Endpoint**: `GET /stats`

**Description**: Get aggregated statistics from the meditation sessions dataset.

**Request**:
```http
GET /stats HTTP/1.1
Host: localhost:5000
```

**Response** (with data):
```json
{
    "total_sessions": 31,
    "avg_duration": 21.45,
    "longest_session": 35,
    "shortest_session": 10
}
```

**Response** (no data):
```json
{
    "total_sessions": 0,
    "avg_duration": 0,
    "longest_session": 0,
    "shortest_session": 0
}
```

**Response Fields**:
- `total_sessions`: Total number of sessions in dataset (integer)
- `avg_duration`: Average session duration in minutes (float, rounded to 2 decimal places)
- `longest_session`: Maximum session duration in minutes (integer)
- `shortest_session`: Minimum session duration in minutes (integer)

**Response Codes**:
- `200 OK`: Statistics calculated successfully

---

### 5. Mood Prediction

**Endpoint**: `POST /predict`

**Description**: Predict post-meditation mood based on session duration and initial mood using the trained ML model.

**Request**:
```http
POST /predict HTTP/1.1
Host: localhost:5000
Content-Type: application/json

{
    "duration_minutes": 20,
    "mood_before": "stressed"
}
```

**Request Body Fields**:
- `duration_minutes`: Session duration in minutes (required, integer, 5-60 range)
- `mood_before`: Initial mood state (required, string)

**Successful Response**:
```json
{
    "mood_after": "calm"
}
```

**Error Response** (Missing fields):
```json
{
    "error": "duration_minutes and mood_before are required"
}
```

**Error Response** (Model not loaded):
```json
{
    "error": "model not loaded"
}
```

**Response Fields**:
- `mood_after`: Predicted post-meditation mood state (string)
- `error`: Error message if prediction fails (string)

**Response Codes**:
- `200 OK`: Prediction successful
- `400 Bad Request`: Invalid or missing request parameters
- `503 Service Unavailable`: ML model not available

**Valid Input Values**:
- `mood_before`: `"stressed"`, `"neutral"`, `"anxious"`, `"tired"`
- `duration_minutes`: Integer between 5 and 60 (reasonable meditation duration)

**Possible Predicted Values**:
- `mood_after`: `"calm"`, `"relaxed"`, `"focused"`, `"energized"`

---

## Error Handling

### Standard Error Format

All API errors follow a consistent JSON format:

```json
{
    "error": "Descriptive error message",
    "code": "ERROR_CODE",
    "timestamp": "2025-09-20T12:00:00Z"
}
```

### Common Error Codes

| HTTP Status | Error Code | Description |
|-------------|------------|-------------|
| 400 | BAD_REQUEST | Invalid request parameters |
| 404 | NOT_FOUND | Endpoint not found |
| 405 | METHOD_NOT_ALLOWED | HTTP method not supported |
| 500 | INTERNAL_ERROR | Server-side error |
| 503 | SERVICE_UNAVAILABLE | Model or data not available |

---

## Usage Examples

### cURL Examples

**Basic Health Check**:
```bash
curl -X GET http://localhost:5000/
```

**Get Statistics**:
```bash
curl -X GET http://localhost:5000/stats
```

**Make Prediction**:
```bash
curl -X POST http://localhost:5000/predict \
  -H "Content-Type: application/json" \
  -d '{
    "duration_minutes": 25,
    "mood_before": "anxious"
  }'
```

### Python Examples

```python
import requests
import json

BASE_URL = "http://localhost:5000"

# Health check
response = requests.get(f"{BASE_URL}/health")
health_data = response.json()
print(f"System status: {health_data['status']}")

# Get all sessions
response = requests.get(f"{BASE_URL}/sessions")
sessions = response.json()
print(f"Total sessions: {len(sessions)}")

# Get statistics
response = requests.get(f"{BASE_URL}/stats")
stats = response.json()
print(f"Average duration: {stats['avg_duration']} minutes")

# Make prediction
prediction_data = {
    "duration_minutes": 30,
    "mood_before": "tired"
}
response = requests.post(
    f"{BASE_URL}/predict",
    headers={"Content-Type": "application/json"},
    data=json.dumps(prediction_data)
)
prediction = response.json()
print(f"Predicted mood: {prediction['mood_after']}")
```

### JavaScript Examples

```javascript
const BASE_URL = 'http://localhost:5000';

// Health check
fetch(`${BASE_URL}/health`)
  .then(response => response.json())
  .then(data => console.log('System status:', data.status));

// Get sessions
fetch(`${BASE_URL}/sessions`)
  .then(response => response.json())
  .then(sessions => console.log('Sessions count:', sessions.length));

// Make prediction
const predictionData = {
  duration_minutes: 15,
  mood_before: 'stressed'
};

fetch(`${BASE_URL}/predict`, {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json'
  },
  body: JSON.stringify(predictionData)
})
.then(response => response.json())
.then(data => console.log('Predicted mood:', data.mood_after))
.catch(error => console.error('Prediction error:', error));
```

---

## Rate Limiting

Currently, no rate limiting is implemented. In a production environment, consider implementing rate limiting to prevent abuse.

**Recommended Limits**:
- General endpoints: 100 requests per minute
- Prediction endpoint: 50 requests per minute

---

## Data Validation

### Input Validation Rules

**Duration Minutes**:
- Type: Integer
- Range: 5-60 minutes
- Required for prediction endpoint

**Mood Before**:
- Type: String
- Allowed values: `stressed`, `neutral`, `anxious`, `tired`
- Case-sensitive
- Required for prediction endpoint

### Response Data Types

All responses use consistent data types:
- Strings: UTF-8 encoded
- Numbers: JSON number format (integers and floats)
- Booleans: `true` or `false`
- Arrays: JSON array format
- Objects: JSON object format

---

## Model Information

### Machine Learning Model Details

**Algorithm**: Logistic Regression with Preprocessing Pipeline  
**Features**: Duration (numeric) + Mood Before (categorical)  
**Target**: Mood After (categorical)  
**Preprocessing**: OneHotEncoder for categorical features  
**Training Data**: 30+ meditation session records  

### Model Performance

**Accuracy**: Validated on training data  
**Cross-validation**: K-fold cross-validation implemented  
**Feature Importance**: Duration and initial mood are primary predictors  

---

## Changelog

### Version 1.0.0 (2025-09-20)
- Initial API release
- Four core endpoints implemented
- ML model integration complete
- Comprehensive error handling
- Health check functionality

---

**API Version**: 1.0.0  
**Last Updated**: September 20, 2025  
**Documentation Status**: Complete