# model/train.py
import pandas as pd
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OneHotEncoder
from sklearn.compose import ColumnTransformer
from sklearn.linear_model import LogisticRegression
import joblib
from pathlib import Path

DATA_PATH = Path("data/group_01/meditation_sessions.csv")
MODEL_PATH = Path("model/model.pkl")

def main():
    df = pd.read_csv(DATA_PATH)
    X = df[["duration_minutes", "mood_before"]]
    y = df["mood_after"]

    pre = ColumnTransformer(
        transformers=[
            ("cat", OneHotEncoder(handle_unknown="ignore"), ["mood_before"]),
        ],
        remainder="passthrough",
    )

    pipe = Pipeline([
        ("pre", pre),
        ("clf", LogisticRegression(max_iter=1000))
    ])

    pipe.fit(X, y)

    MODEL_PATH.parent.mkdir(parents=True, exist_ok=True)
    joblib.dump(pipe, MODEL_PATH)
    print("✅ Model trained and saved to", MODEL_PATH)

if __name__ == "__main__":
    main()
