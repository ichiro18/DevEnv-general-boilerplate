#!/usr/bin/env bash

#== Import script args ==

github_token=$(echo "$1")

#== Bash helpers ==

function info {
  echo " "
  echo "--> $1"
  echo " "
}

#== Provision script ==

info "Provision-script user: `whoami`"

info "Configure console"
sed -i "s/#force_color_prompt=yes/force_color_prompt=yes/" /home/vagrant/.bashrc

info "Install GVM"
bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
source ~/.gvm/scripts/gvm

info "Install GO"
gvm install go1.9 -B
cd /GO
gvm use go1.9
gvm pkgset create --local
gvm pkgset use --local

#TODO(ichiro18): Сделать название папки переменной
info "Create App folder"
mkdir -p /GO/src/App