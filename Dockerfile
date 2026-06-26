FROM python:3.9-slim

# Install Docker
RUN apt-get update && \
    apt-get install -y docker.io && \
    usermod -aG docker jenkins

# Set the working directory
WORKDIR /usr/src/app

# Copy application files
COPY src/app.py ./
COPY requirements.txt ./

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose the application port
EXPOSE 5500

# Command to run the application
CMD ["python", "app.py"]

# Instructions for manual checking
# To check the application, you can access it in a browser at http://localhost:5500
# or use curl: curl http://localhost:5500
