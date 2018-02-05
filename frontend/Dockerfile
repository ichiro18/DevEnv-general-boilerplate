#FROM centos:centos7
#MAINTAINER Ilya Zhuravlev <zhuravlev@dipay.ru>

#EXPOSE 8080
#
#COPY server.js .
#CMD node server.js

FROM ubuntu:16.04
RUN apt update && \
    apt install -y --no-install-recommends openssh-server sudo

RUN useradd --create-home --user-group vagrant && \
    echo -n 'vagrant:vagrant' | chpasswd && \
    echo 'vagrant ALL=NOPASSWD: ALL' >/etc/sudoers.d/vagrant

RUN mkdir -p /var/run/sshd
CMD /usr/sbin/sshd -D
