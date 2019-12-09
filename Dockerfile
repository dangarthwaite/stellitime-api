FROM python:3-alpine
WORKDIR /app

RUN apk add --no-cache build-base
COPY ./requirements.txt .
RUN pip install -r requirements.txt
ENV AWS_SECRET_ACCESS_KEY PsudeoSecret
ENV AWS_ACCESS_KEY_ID PseudoKeyId
ENV AWS_DEFAULT_REGION us-east-1
ENV DYNAMODB_LOCAL 1

COPY . .
RUN make test
