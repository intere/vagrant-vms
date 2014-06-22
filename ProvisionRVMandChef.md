RVM & Chef
====

To setup RVM & Chef on a VM, execute the following commands:

    # First - install RVM:
    $ curl -sSL https://get.rvm.io | sudo bash -s stable

    # Source RVM:
    $ source /etc/profile.d/rvm.sh

    # Add the vagrant user to the rvm group:
    # vagrant user has to logout and log back it to see this change
    $ sudo usermod -a -G rvm vagrant

    # Assuming you've logged out and back in, then...
    # Install Ruby 1.9.3
    $ rvm install 1.9.3
    $ rvm use 1.9.3 --default

    # Now, install chef
    $ gem install chef --no-ri --no-rdoc
    $ chef-solo -v
    # also install knife-solo
    $ gem install knife-solo --no-ri --no-rdoc

## Resources
* https://www.digitalocean.com/community/tutorials/how-to-install-chef-and-ruby-with-rvm-on-a-ubuntu-vps
* https://rvm.io/rvm/install
* https://rvm.io/rvm/basics
