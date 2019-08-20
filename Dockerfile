FROM ubuntu:14.04

MAINTAINER Peter Hastie <phastie@bleacherreport.com>

RUN cp /etc/apt/sources.list /etc/apt/sources.list.bk
RUN sed -i 's%archive.ubuntu.com%mirrors.aliyun.com/ubuntu/%' /etc/apt/sources.list

RUN apt-get update && apt-get install -qy \
  build-essential

WORKDIR /app
ADD . /app

RUN g++ -Wall -std=c++11 src/inotify-proxy.cpp -o /usr/bin/inotify-proxy

CMD ["inotify-proxy"]
