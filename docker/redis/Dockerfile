# Dockerfile for redis image
#
# Build using:
# $ docker build --rm --no-cache -t redis .
#
FROM baseimage
MAINTAINER "Tom" <nospam@invalid>
# install Redis (https://github.com/dockerfile/redis/)
RUN yum -y install wget gcc make ; yum clean all ; \
  cd /tmp && \
  wget http://download.redis.io/redis-stable.tar.gz && \
  tar xvzf redis-stable.tar.gz && \
  cd redis-stable && \
  make && \
  make install && \
  cp -f src/redis-sentinel /usr/local/bin && \
  rm -rf /tmp/redis-stable* 
# copy redis.conf and sentinel.conf to /etc/redis/
COPY files/ /
EXPOSE 6379
WORKDIR /data
# TODO: start Redis with sentinel http://redis.io/topics/sentinel
CMD ["redis-server", "/etc/redis/redis.conf", "--protected-mode no"]
