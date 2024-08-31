# Base image
FROM python:3.11-slim as python-base

# Dependencies
RUN apt-get update && apt-get install -y curl build-essential
RUN pip3 install --no-cache-dir --target=packages --upgrade fastapi[standard] pymongo motor pydantic-settings httpx pytest pytest-asyncio pytest-order

# Runtime stage for dev
FROM python:3.11-slim as development
COPY --from=python-base packages /usr/lib/python3.11/site-packages
ENV PYTHONPATH=/usr/lib/python3.11/site-packages

# Security
RUN useradd -m nonroot
USER nonroot

# Environment
ENV ENV=dev
COPY . .
EXPOSE 8000
ENTRYPOINT ["python", "-m", "src.server"]
