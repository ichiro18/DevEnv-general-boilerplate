#!/usr/bin/env bash

#== Import script args ==

timezone=$(echo "$1")

#== Bash helpers ==

function info {
  echo " "
  echo "--> $1"
  echo " "
}

#== Provision script ==

info "Provision-script user: `whoami`"

info "Configure timezone"
timedatectl set-timezone ${timezone} --no-ask-password

info "Update OS software"
yum update
yum upgrade -y

info "Install System Packages"
yum install -y mc

info "Install VCS"
yum install -y git mercurial

info "Install GVM Requirements"
yum install -y curl make bison gcc glibc-devel
mkdir /GO
chown -R vagrant:vagrant /GO