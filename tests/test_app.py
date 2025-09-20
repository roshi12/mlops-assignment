from app import app


def client():
    return app.test_client()


def test_root_ok():
    res = client().get("/")
    assert res.status_code == 200
    assert res.get_json()["status"] == "ok"


def test_stats_keys():
    res = client().get("/stats")
    assert res.status_code == 200
    stats = res.get_json()
    for k in ["total_sessions", "avg_duration", "longest_session", "shortest_session"]:
        assert k in stats


def test_sessions_list():
    res = client().get("/sessions")
    assert res.status_code == 200
    assert isinstance(res.get_json(), list)


def test_predict_requires_fields():
    res = client().post("/predict", json={})
    assert res.status_code == 400


def test_predict_valid_input():
    res = client().post("/predict", json={"duration_minutes": 15, "mood_before": "neutral"})
    # Either 200 (prediction ok) or 503 (model not loaded)
    assert res.status_code in (200, 503)


def test_health_check():
    """Test the new health check endpoint"""
    res = client().get("/health")
    assert res.status_code == 200
    health = res.get_json()
    assert "status" in health
    assert "data_loaded" in health
    assert "model_loaded" in health
    assert health["status"] == "healthy"
