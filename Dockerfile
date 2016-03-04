FROM debian:jessie

MAINTAINER Peter Hastie <phastie@bleacherreport.com>

RUN apt-get update && apt-get install -qy \
  build-essential \
  vim

WORKDIR /app
ADD . /app

CMD ["make"]
