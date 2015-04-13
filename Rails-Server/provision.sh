GIT_REPO=git@bitbucket.org:weedray/on-weed.git;

installPrerequisites() {
  if [ ! -e /etc/apache2 ] ; then
    export DEBIAN_FRONTEND=noninteractive
    echo "mysql-server-5.5 mysql-server/root_password password root" | debconf-set-selections
    echo "mysql-server-5.5 mysql-server/root_password_again password root" | debconf-set-selections
    apt-get -y install mysql-server-5.5 git libmysqlclient-dev apache2 apache2-dev libcurl4-openssl-dev
    mysqladmin -uroot -proot password ''
  else
    echo "Apache appears to be installed, skipping package installation";
  fi

  if [ ! -e /tmp/mysql.sock ] ; then
    ln -s /var/run/mysqld/mysqld.sock /tmp/mysql.sock
  fi

  installRvm;
  installNvm;
}

installNvm() {
  if [ ! -e /usr/local/nvm ] ; then
    export NVM_DIR=/usr/local/nvm;
    curl https://raw.githubusercontent.com/creationix/nvm/v0.24.1/install.sh | bash
    chown -R root:rvm /usr/local/nvm
    su - vagrant -c "echo 'source /usr/local/nvm/nvm.sh' >> ~/.profile";
    su - vagrant -c "nvm install v0.12.2";
    su - vagrant -c "nvm use v0.12.2; npm install -g bower";
  else
    "NVM is already provisioned on this system.  Skipping...";
  fi
}

installRvm() {
  if [ "$RVM" == "" ] ; then
    echo "Installing RVM..."
    curl -sSL https://get.rvm.io | bash 
    source /etc/profile.d/rvm.sh
    echo "source /etc/profile.d/rvm.sh" >> ~vagrant/.profile
    echo "source /etc/profile.d/rvm.sh" >> ~/.profile
    rvm install 2.1
    echo "gem: --no-ri --no-document # skip installation of all documentation" > ~/.gemrc

    # Add rvm group to Vagrant User.
    usermod -a -G rvm vagrant
    su - vagrant -c 'echo "gem: --no-ri --no-document # skip installation of all documentation" > ~/.gemrc'
    su - vagrant -c 'gem install rails bundler passenger'
  else
    echo "RVM is already provisioned on this system.  Skipping...";
  fi
}

configureSsh() {
  if [ ! -e ~vagrant/.ssh ] ; then
    su - vagrant -c 'mkdir ~/.ssh';
  fi
  if [ ! -e ~vagrant/.ssh/id_rsa ] ; then
    su - vagrant -c 'cp /vagrant/id_rsa* ~/.ssh';
    su - vagrant -c 'echo -e "Host bitbucket.org\n\tStrictHostKeyChecking no" > ~/.ssh/config';
    su - vagrant -c 'chmod 644 ~/.ssh/config';
  fi
}

setupPassenger() {
  LOG=/tmp/setup-passenger.log
  if [ ! -e /usr/local/rvm/gems/ruby-2.1.5/gems/passenger-5.0.6/buildout/apache2/mod_passenger.so ] ; then
    passenger-install-apache2-module -a 2>&1|tee ${LOG}
    echo "LoadModule passenger_module /usr/local/rvm/gems/ruby-2.1.5/gems/passenger-5.0.6/buildout/apache2/mod_passenger.so" > /etc/apache2/mods-available/passenger.load
    echo -e "<IfModule mod_passenger.c>\n\tPassengerRoot /usr/local/rvm/gems/ruby-2.1.5/gems/passenger-5.0.6\n\tPassengerDefaultRuby /usr/local/rvm/gems/ruby-2.1.5/wrappers/ruby\n</IfModule>" > /etc/apache2/mods-available/passenger.conf
    cd /etc/apache2/mods-enabled/
    ln -s ../mods-available/passenger.* .
    cp /vagrant/on-weed.conf /etc/apache2/sites-available/
    cd /etc/apache2/sites-available
    rm 000-default
    ln -s ../sites-available/on-weed.conf on-weed 
    apache2ctl restart
  else
    echo "ERROR: Didn't find apache mod passenger";
  fi
}

checkoutCode() {
  cd ~vagrant;
  if [ ! -e ~/code ] ; then
    su - vagrant -c 'mkdir ~/code';
  fi

  cd ~vagrant/code
  DO_CONFIGURE=0;
  if [ ! -e on-weed ] ; then
    su - vagrant -c "cd ~/code; git clone ${GIT_REPO}";
    DO_CONFIGURE=1;
  else
    su - vagrant -c "cd ~/code/on-weed; git pull origin master";
  fi

  PWD="~vagrant/code/on-weed";
  echo "Working in directory: ${PWD}";
  #su - vagrant -c "cd ${PWD}; gem install mysql2 -v '0.3.17'";
  su - vagrant -c "echo 'global' > ${PWD}/.ruby-gemset"
  su - vagrant -c "cd ${PWD}; bundle install";
  su - vagrant -c "cd ${PWD}; nvm use v0.12.2; bower update";
  
  if [ ${DO_CONFIGURE} == 1 ] ; then
    configureApplication;
  fi
}

configureApplication() {
  PWD="~vagrant/code/on-weed";

  su - vagrant -c "cd ${PWD}; bundle exec rake db:drop db:create db:migrate db:seed"  # Setup DB
  su - vagrant -c "cd ${PWD}; bundle exec rake data:populate_dispensaries"            # Import Dispensaries
  su - vagrant -c "cd ${PWD}; bundle exec rake data:populate_menus"                   # Import Menus
  su - vagrant -c "cd ${PWD}; bundle exec rake data:populate_all_products"            # Create Products from Menus 
}

main() {
  echo "Information: "
  echo "I am: $(whoami)"
  echo "Groups: $(groups)"
  echo "Working Directory: $(pwd)"

  installPrerequisites;
  configureSsh;
  checkoutCode;
  setupPassenger;  
}

main;

