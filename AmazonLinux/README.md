AmazonLinux
====

##Purpose##
I've created this vagrant configuration so that I can play with ec2 instances locally (and
  hopefully test opsworks configurations locally).

##What does it do?##
So far, it pulls the Virtual Box Image and boots it, and that's about it.  More to come...

##References##
This is built on top of the work that was done in the following blog post:
[Amazon Linux Vagrant Box Images](https://www.geekandi.com/2014/04/13/amazon-linux-vagrant-box-images/)

##Users##
* vagrant (vagrant user - who you are when you SSH in)
* ec2-user (ec2 user, I'm not sure what the password is, it isn't "ec2-user" as the
blog post suggests, but you can override it quite easily - see the usage below)

##Usage##
    # Fire up the VM:
    $ vagrant init
    # SSH Into the VM (shell access) - as vagrant user
    $ vagrant ssh

    # Now you're ssh'd in (as the vagrant user).  Switch to ec2-user:
    [vagrant@ec2-vagrant ~]$ sudo su - ec2-user

    # Now you're the ec2-user
    [ec2-user@ec2-vagrant ~]$

    # Now if you'd like to set the password for the ec2-user, you can:
    [ec2-user@ec2-vagrant ~]$ sudo su - root -c "passwd ec2-user"
    Changing password for user ec2-user.
    New password:
    Retype new password:
    passwd: all authentication tokens updated successfully.
    [ec2-user@ec2-vagrant ~]$
    

