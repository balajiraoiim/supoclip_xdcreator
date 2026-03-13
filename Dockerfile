FROM python:3.11-slim

WORKDIR /app

# install system dependencies
RUN apt-get update && apt-get install -y ffmpeg && rm -rf /var/lib/apt/lists/*

# copy only backend dependency files first
COPY backend/pyproject.toml backend/uv.lock ./backend/

# install python dependencies
RUN pip install --upgrade pip
RUN pip install ./backend

# now copy the rest of the code
COPY . .

WORKDIR /app/backend

EXPOSE 8080

CMD uvicorn src.main:app --host 0.0.0.0 --port ${PORT:-8080}
