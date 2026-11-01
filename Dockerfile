FROM python:3.11-slim

WORKDIR /app

# Install dependencies first so Docker can cache this layer
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

EXPOSE 8000

# gunicorn serves the Flask app "app" from app.py on port 8000
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]
