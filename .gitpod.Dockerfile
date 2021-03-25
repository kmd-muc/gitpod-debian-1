FROM debian:10

RUN apt-get update && \
    apt-get install -yq sudo
