from flask import Flask, jsonify, request
import pandas as pd
import joblib
from pathlib import Path

app = Flask(__name__)

DATA_PATH = Path("data/group_01/meditation_sessions.csv")
MODEL_PATH = Path("model/model.pkl")

# Load dataset if available
df = pd.read_csv(DATA_PATH) if DATA_PATH.exists() else pd.DataFrame()

# Load model if available
model = joblib.load(MODEL_PATH) if MODEL_PATH.exists() else None


@app.route("/")
def home():
    """
    Health check endpoint for the Focus Meditation Agent API.

    Returns:
        JSON response with status and message
    """
    return jsonify({"status": "ok", "msg": "Focus Meditation Agent"})


@app.route("/sessions")
def get_sessions():
    """
    Return all meditation sessions as JSON.

    Returns:
        JSON array of meditation session records from the dataset
    """
    if df.empty:
        return jsonify([])  # return empty list if no data
    return jsonify(df.to_dict(orient="records"))


@app.route("/stats")
def get_stats():
    """Return summary stats from dataset"""
    if df.empty:
        return jsonify({
            "total_sessions": 0,
            "avg_duration": 0,
            "longest_session": 0,
            "shortest_session": 0,
        })

    stats = {
        "total_sessions": int(len(df)),
        "avg_duration": round(float(df["duration_minutes"].mean()), 2),
        "longest_session": int(df["duration_minutes"].max()),
        "shortest_session": int(df["duration_minutes"].min()),
    }
    return jsonify(stats)


@app.route("/health")
def health_check():
    """
    Detailed health check endpoint with system information.

    Returns:
        JSON response with system status, data availability, and model status
    """
    return jsonify({
        "status": "healthy",
        "timestamp": "2025-09-20T12:00:00Z",
        "data_loaded": not df.empty,
        "model_loaded": model is not None,
        "version": "1.0.0"
    })


@app.route("/predict", methods=["POST"])
def predict():
    """Predict mood_after from duration_minutes and mood_before"""
    if model is None:
        return jsonify({"error": "model not loaded"}), 503

    payload = request.get_json(force=True) or {}
    duration = payload.get("duration_minutes")
    mood_before = payload.get("mood_before")

    if duration is None or mood_before is None:
        return jsonify({"error": "duration_minutes and mood_before are required"}), 400

    X = pd.DataFrame([{"duration_minutes": duration, "mood_before": mood_before}])
    yhat = model.predict(X)[0]
    return jsonify({"mood_after": str(yhat)})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
