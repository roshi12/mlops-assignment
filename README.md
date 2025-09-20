# Focus Meditation Agent - CI/CD Project

## Branching Strategy
- `dev`: feature development
- `test`: run automated unit tests before production
- `master`: production-ready, triggers Jenkins pipeline

## CI/CD Flow
1. Push to `dev` → triggers lint (flake8)
2. PR dev → test → triggers pytest
3. PR test → master → triggers Jenkins job → Docker build + push → email admin

## Run Locally
```bash
pip install -r requirements.txt
flask run
```

## Run with Docker
```bash
docker build -t focus-agent .
docker run -p 5000:5000 focus-agent
```

## Dataset
Unique dataset placed under `data/group_<id>/`.
