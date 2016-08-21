# Dockerfile for application image
#
# Build using:
# $ docker build --rm --no-cache -t app .
#
FROM baseimage
MAINTAINER "Tom" <nospam@invalid>
# sinatra will use Thin (event based) if available
# update rdoc to avoid https://github.com/sinatra/sinatra/issues/1089
RUN yum -y install ruby ruby-devel rubygems openssl-devel gcc gcc-c++ make ; yum clean all; \ 
        gem update rdoc; gem install redis sinatra thin
ENV REDIS_HOST=redis
ENV REDIS_PORT=6379
EXPOSE 4567
COPY files/ /
CMD ["ruby", "/opt/webapp/hello-world.rb", "-e production", "-o 0.0.0.0", "-p 4567"]
