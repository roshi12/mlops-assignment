from app import app

def test_root():
    client = app.test_client()
    res = client.get("/")
    assert res.status_code == 200
    data = res.get_json()
    assert data["status"] == "ok"
    assert data["msg"] == "Focus Meditation Agent"

def test_sessions():
    client = app.test_client()
    res = client.get("/sessions")
    assert res.status_code == 200
    sessions = res.get_json()
    # check dataset length (should be 30)
    assert isinstance(sessions, list)
    assert len(sessions) == 30
    # check fields
    first = sessions[0]
    assert "date" in first
    assert "duration_minutes" in first
    assert "mood_before" in first
    assert "mood_after" in first

def test_stats():
    client = app.test_client()
    res = client.get("/stats")
    assert res.status_code == 200
    stats = res.get_json()
    # check required keys
    assert "total_sessions" in stats
    assert "avg_duration" in stats
    assert "longest_session" in stats
    assert "shortest_session" in stats
    # validate numbers
    assert stats["total_sessions"] == 30
    assert stats["longest_session"] == 35
    assert stats["shortest_session"] == 10
