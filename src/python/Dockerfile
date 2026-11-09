
FROM python:3.15-slim

WORKDIR /app

# Copy the package requirements
COPY src/python/requirements.txt /app/requirements.txt

# Install Python packages
RUN pip install --no-cache-dir -r /app/requirements.txt

# Copy the Python script
COPY src/python/titanic_model.py /app/src/python/titanic_model.py

# Run the Titanic model
CMD ["python", "/app/src/python/titanic_model.py"]
