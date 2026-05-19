FROM python:3.11-slim AS builder

ENV PIP_NO_CACHE_DIR=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY src/requirements.txt ./src/requirements.txt
RUN pip install --upgrade pip && pip install -r src/requirements.txt

FROM python:3.11-slim AS runner

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/opt/venv/bin:$PATH"

WORKDIR /app

COPY --from=builder /opt/venv /opt/venv
COPY src ./src
COPY data ./data
COPY .sample_env ./.sample_env

EXPOSE 8501

CMD ["streamlit", "run", "src/Home.py", "--server.address=0.0.0.0", "--server.port=8501"]
