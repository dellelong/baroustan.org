FROM python:3.6-alpine as build

RUN mkdir /app
WORKDIR /app

ADD Pipfile Pipfile.lock ./

RUN apk update -q && apk add -q \
    git \
    py3-pillow \
 && pip3 install -U pip \
 && pip3 install pipenv \
 && pipenv install --system --deploy

ENV PYTHONPATH=/usr/lib/python3.6/site-packages

ADD . .

ARG DOMAIN_NAME=local

RUN pelican

FROM nim65s/ndh:nginx

COPY --from=build /app/output /srv
