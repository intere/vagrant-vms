#!/bin/bash

installRbenv() {

  # if RBENV isn't installed, then "install" it
  if [ ! -e ~/.rbenv ] ; then
    git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~vagrant/.bash_profile
    echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
    echo 'eval "$(rbenv init -)"' >> ~vagrant/.bash_profile
  fi

  # if ruby-build isn't installed, then install ruby-build 
  if [ ! -e ~/.rbenv/plugins/ruby-build ] ; then
    git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
    cd ~/.rbenv/plugins/ruby-build
    ./install.sh
  fi
  
  # invoke a subshell to install ruby 2.1.0
  if [ ! -e ~/.rbenv/versions/2.1.0 ] ; then
    /bin/bash -c "rbenv install 2.1.0"
  fi
  
  cp -r ~/.rbenv ~vagrant/
  chown -R vagrant:vagrant ~vagrant/.rbenv
  /bin/bash -c "rbenv global 2.1.0"
  sudo su - vagrant -c "rbenv global 2.1.0"
}

checkRbenv() {

  rbenv=$(type rbenv 2>/dev/null)

  #if [ "${rbenv}" == "" ] ; then
    installRbenv;
  #fi
}

checkRbenv;

