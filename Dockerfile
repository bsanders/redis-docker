#
# Redis Dockerfile
#
# Based on https://github.com/dockerfile/redis

# To use this dockerfile, create a data container
# sudo docker run -d -v /data --name redis_data ubuntu:latest echo Data-only container for redis
# The create this container and link it via --volumes-from
# docker build -t "ubuntu_redis" .
# docker run -d --name redis_container --volumes-from redis_data -p 6379:6379 -t ubuntu_redis

# Pull base image.
FROM ubuntu:latest

# Install Redis.
# Ignore weird permissions / selinux error
RUN ln -s -f /bin/true /usr/bin/chfn

RUN apt-get update
RUN apt-get install -y redis-server

RUN \
  sed -i 's/^\(bind .*\)$/# \1/' /etc/redis/redis.conf && \
  sed -i 's/^\(daemonize .*\)$/# \1/' /etc/redis/redis.conf && \
  sed -i 's/^\(dir .*\)$/# \1\ndir \/data/' /etc/redis/redis.conf && \
  sed -i 's/^\(logfile .*\)$/# \1/' /etc/redis/redis.conf

# Define mountable directories.
VOLUME ["/data"]

# Define working directory.
WORKDIR /data

# Define default command.
CMD ["redis-server", "/etc/redis/redis.conf"]

# Expose ports.
EXPOSE 6379
