FROM python:3.12.5-slim

WORKDIR /app

COPY . /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

RUN apt-get update && apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

RUN npm install

RUN npm run build

EXPOSE 5053

ENV PORT=5053
ENV TZ="America/Guatemala"
ENV STATIC_RECORDINGS_PATH="/app/static/Recordings"
ENV RECORDING_STATUS_PATH="/app/static/recording_status.json"
ENV REFRESH_ARCHIVE_DATA_INTERVAL_MINUTES="5"
ENV REFRESH_ACTIVE_BROADCASTS_DATA_INTERVAL_MINUTES="5"
ENV REFRESH_RECORDING_STATUS_DATA_INTERVAL_MINUTES="1"
ENV REFRESH_SCHEDULE_DATA_INTERVAL_MINUTES="5"
ENV REFRESH_LOVE_TAPS_CACHE_INTERVAL_MINUTES="5"
ENV REFRESH_TRENDING_ARCHIVES_INTERVAL_MINUTES="5"
ENV POSTGRES_USER="admin"
ENV POSTGRES_PASSWORD=""
ENV POSTGRES_DB="hbni"
ENV POSTGRES_HOST="172.17.0.1"
ENV POSTGRES_PORT="5434"
ENV POSTGRES_MIN_SIZE="1"
ENV POSTGRES_MAX_SIZE="10"
ENV ICECAST_BROADCASTING_SOURCE="https://hbniaudio.hbni.net"
ENV ICECAST_BROADCASTING_IP="162.249.41.15"
ENV ICECAST_BROADCASTING_PORT="8000"
ENV ICECAST_BROADCASTING_PASSWORD=""
ENV PRIVATE_ICECAST_BROADCASTING_SOURCE="https://broadcasting.hbni.net"
ENV PRIVATE_ICECAST_BROADCASTING_IP="172.17.0.1"
ENV PRIVATE_ICECAST_BROADCASTING_PORT="8000"
CMD ["python", "main.py"]
