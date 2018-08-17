FROM alpine

MAINTAINER Thomas Metzmacher <thomas@metzmacher.me>

RUN apk add --update g++

RUN mkdir /app

WORKDIR /app
ADD . /app

RUN g++ -Wall -std=c++11 src/inotify-proxy.cpp -o /usr/bin/inotify-proxy

CMD ["inotify-proxy"]
