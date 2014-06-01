vagrant-vms
====

The purpose of this repository is to tinker with Vagrant Virtual Machines.

I've got a blog post that is in progress that I'm working on (this repo contains the code
  behind this blog).

Blog Page:  https://sites.google.com/site/colasoftwareblog/creating-your-own

##Layout##

Each folder in this project is a basic VM.  So far what I'm working on is creating a
custom (base) CentOS-6.4 VM that is provisioned in the following way:
* CentOS-6.4 - Bare Bones CentOS 6.4 VM and (shell script based) configuration to
install RVM, Ruby and Chef.

#CentOS-6.4#
I wanted to start with a (small) bare bones CentOS VM that I could build off of (
install RVM, Ruby, Chef).  This should allow me to create a new box based on this VM
after provisioning is complete.

##Box Creation Process##
Step 1 - provision the CentOS VM with RVM, Ruby and Chef.

    $ cd CentOS-6.4
    $ vagrant up  # this will take a while to provision

Step 2 - validate that it's provisioned:

    $ vagrant ssh # next prompt is on the guest VM
    $ ruby --version  # should produce the following output:
    ruby 1.9.3p547 (2014-05-14 revision 45962) [x86_64-linux]

Step 3 - repackage the VM into a *new* base box:

    # After that's done, you need to list your VirtualBox VMs:
    $ VBoxManage list runningvms

    # produces output like this:
    "Ubuntu-1004_default_1401637394163_32249" {7702c784-ac03-4359-8973-798765983fa1}
    "CentOS-64_default_1401638923622_5778" {56a0e2aa-c613-4119-a2b9-14063a470adf}

    # since it's the CentOS VM that I want to package into a new box, I'll run this command:
    $ vagrant package --base 'CentOS-64_default_1401638923622_5778' --output centos-6.4-chef.box
    # this takes a few minutes and creates the following file:
    # centos-6.4-chef.box

Step 4 - install the base box into vagrant

    $ vagrant box add centos-6.4-chef file://$(pwd)/centos-6.4-chef.box
    # Now verify that it was added successfully:
    $ vagrant box list  # should produce output similar to:
    Ubuntu-Server-12.04  (virtualbox)
    centos-6.4           (virtualbox)
    centos-6.4-chef      (virtualbox)
    lucid                (virtualbox)
    opscode-ubuntu-13.04 (virtualbox)
    # Note the line: centos-6.4-chef      (virtualbox)

Success!
