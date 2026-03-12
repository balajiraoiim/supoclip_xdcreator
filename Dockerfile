FROM python:3.11-slim

WORKDIR /app

# install system deps
RUN apt-get update && apt-get install -y ffmpeg && rm -rf /var/lib/apt/lists/*

# copy project
COPY . .

# install python dependencies
RUN pip install --upgrade pip
RUN pip install -r backend/requirements.txt

# move into backend
WORKDIR /app/backend

# expose port
EXPOSE 8080

# run server
CMD uvicorn main:app --host 0.0.0.0 --port ${PORT:-8080}
