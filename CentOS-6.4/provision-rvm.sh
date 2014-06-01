#!/bin/bash
#####################################################################
#
# The purpose of this script is to setup RVM, Ruby and Chef.  The 
# assumption is that your system is CentOS (yum-based).
#   What it does:
#      1.  Installs RVM (if not already installed)
#      2.  Installs RVM requirements (rvm requirements)
#      3.  Install Ruby 1.9.3 (under RVM)
#      4.  Patches the /etc/profile to source RVM
#      5.  Updates the /root/.bash_profile to source /etc/profile
#      6.  Updates the /home/vagrant/.bash_profile to source /etc/profile
#      7.  Installs Ruby Gems
#      8.  Installs the chef gem
#
#####################################################################

# If RVM isn't installed, then install it.
found=$(which rvm)
if [ "$found" == "" ] ; then
  yum update
  yum install curl
  curl -L get.rvm.io | bash -s stable
fi

RVM=/usr/local/rvm/bin/rvm
$RVM requirements

source /usr/local/rvm/scripts/rvm

# Install ruby 1.9.3
found=$(rvm list | grep ruby-1.9.3)
if [ "${found}" == "" ] ; then 
  $RVM install 1.9.3
fi

# Patch /etc/profile (if necessary)
found=$(grep rvm /etc/profile)
if [ "${found}" == "" ] ; then
  echo "source /usr/local/rvm/scripts/rvm" >> /etc/profile
fi

# Hack the root profile
found=$(grep /etc/profile /root/.bash_profile)
if [ "${found}" == "" ] ; then
  echo "source /etc/profile" > /tmp/.profile
  cat /root/.bash_profile >> /tmp/.profile
  echo "rvm use 1.9.3 > /dev/null" >> /tmp/.profile
  mv /tmp/.profile /root/.bash_profile
fi

# Hack the vagrant profile
found=$(grep /etc/profile ~vagrant/.bash_profile)
if [ "${found}" == "" ] ; then
  echo "source /etc/profile" > /tmp/.profile
  cat ~vagrant/.bash_profile >> /tmp/.profile
  echo "rvm use 1.9.3 > /dev/null" >> /tmp/.profile
  mv /tmp/.profile ~vagrant/.bash_profile 
fi

source ~/.bash_profile
$RVM rubygems current

echo "Installing Chef"
gem install chef


