from flask import Flask, jsonify
import pandas as pd

app = Flask(__name__)

# Load dataset
DATA_PATH = "data/group_01/meditation_sessions.csv"
df = pd.read_csv(DATA_PATH)

@app.route("/")
def home():
    return jsonify({"status": "ok", "msg": "Focus Meditation Agent"})

@app.route("/sessions")
def get_sessions():
    """Return all meditation sessions as JSON"""
    return df.to_json(orient="records")

@app.route("/stats")
def get_stats():
    """Return summary statistics from dataset"""
    stats = {
        "total_sessions": len(df),
        "avg_duration": round(df["duration_minutes"].mean(), 2),
        "longest_session": int(df["duration_minutes"].max()),
        "shortest_session": int(df["duration_minutes"].min())
    }
    return jsonify(stats)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
