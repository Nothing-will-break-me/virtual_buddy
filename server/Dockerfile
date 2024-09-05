# Base image
FROM python:3.11-slim AS python-base

# Dependencies
RUN apt-get update && apt-get install -y curl build-essential openssl
RUN pip3 install --no-cache-dir --target=packages --upgrade fastapi[standard] pymongo motor pydantic-settings \
httpx pytest pytest-asyncio pytest-order pyjwt passlib bcrypt==4.0.1

# Runtime stage for dev
FROM python-base AS certificates
COPY --from=python-base packages /usr/lib/python3.11/site-packages
ENV PYTHONPATH=/usr/lib/python3.11/site-packages
RUN mkdir -p ./certs
RUN openssl req -x509 -newkey rsa:4096 -nodes -out certs/cert.pem -keyout certs/key.pem -days 365 \
-subj "/C=US/ST=State/L=City/O=Organization/OU=Unit/CN=localhost"

FROM certificates AS development
# Security
RUN useradd -m nonroot
USER nonroot

# Environment
ENV ENV=dev
COPY . .
EXPOSE 8000
ENTRYPOINT ["python", "-m", "src.server"]
