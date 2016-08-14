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
EXPOSE 4567
COPY files/ /
CMD ["ruby", "/opt/webapp/hello-world.rb"]
