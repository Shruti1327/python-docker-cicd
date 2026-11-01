# Python Docker CI/CD

A simple Flask service, packaged in Docker and built, deployed and health-checked
by a GitHub Actions workflow.

## Project structure

```
python-docker-cicd/
├── app.py                  # Flask app: / and /health
├── requirements.txt        # Flask and gunicorn
├── Dockerfile              # Builds the container image
├── .github/workflows/deploy.yml   # CI/CD pipeline
└── README.md
```

## Setup

1. Create a GitHub repository and push these files to the `main` branch.
2. GitHub Actions is enabled by default. No secrets are needed.

## Running the pipeline

- **Automatic:** every push to `main` runs the workflow.
- **Manual:** go to the **Actions** tab, select **Build and Deploy Python Service**,
  click **Run workflow**, then **Run workflow** again.

The pipeline:
1. Checks out the code.
2. Builds the Docker image.
3. Runs the container and publishes port 8000.
4. Calls `/health` (with retries while the app starts) and `/`.
5. Confirms the container is running, and shows logs if something fails.
6. Removes the container at the end, whether the run passed or failed.

## Verifying locally

Requires Docker.

```bash
# Build the image
docker build -t python-service .

# Run the container
docker run -d --name python-service -p 8000:8000 python-service

# Check the container is running
docker ps --filter name=python-service

# Test the endpoints
curl http://localhost:8000/
curl http://localhost:8000/health
# Expected: {"status":"healthy"}

# View logs, then clean up
docker logs python-service
docker rm -f python-service
```

## Test the app without Docker

```bash
pip install -r requirements.txt
python app.py
# In another terminal:
curl http://localhost:8000/health
```
