#!/bin/bash

RVM=$(type rvm)

if [ "$RVM" == "" ] ; then
  echo "Installing RVM..."
  curl -sSL https://get.rvm.io | sudo bash -s stable --ruby=1.9.3
  source /etc/profile.d/rvm.sh
  sudo usermod -a -G rvm vagrant
  rvm use 1.9.3 --default
  gem install chef --no-ri --no-rdoc
  gem install knife-solo --no-ri --no-rdoc
else
  echo "RVM is already provisioned on this system"
fi
