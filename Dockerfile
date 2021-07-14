FROM ubuntu:14.04

MAINTAINER Peter Hastie <phastie@bleacherreport.com>

RUN apt-get update && apt-get install -qy build-essential

WORKDIR /app
ADD . /app

RUN g++ -Wall -std=c++11 src/inotify-proxy.cpp -o /usr/bin/inotify-proxy

CMD ["inotify-proxy"]
