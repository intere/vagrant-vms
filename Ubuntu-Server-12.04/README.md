Ubuntu-Server-12.04
====
This VM fires up and provisions Ubuntu Server 12.04 with RVM, Ruby 1.9.3 and Chef.

After you've fired it up, you can build a box based on it using the
"Box Creation Process" spelled out in the root [README.md](../README.md)

FYI - you'll want to call the new box: Ubuntu-Server-12.04-chef

## Reboxing Example ##
Here's an example of what I did to rebox this VM:

    $ vagrant up
    Bringing machine 'default' up with 'virtualbox' provider...
    ==> default: Importing base box 'Ubuntu-Server-12.04'...
    ==> default: Matching MAC address for NAT networking...
    ==> default: Setting the name of the VM: Ubuntu-Server-1204_default_1403455990838_73500
    ...
    ==> default: Successfully installed knife-solo-0.4.2
    ==> default: 1 gem installed

    $ VBoxManage list runningvms                                                                                                   [10:56:55]
    "CentOS-64-chef_default_1403454322144_4306" {e0fb686c-a27d-4d64-84c0-9531c71f7934}
    "Ubuntu-Server-1204_default_1403455990838_73500" {11301a84-afc6-4612-b330-5f6b9ef5046b}

    $ vagrant package --base 'Ubuntu-Server-1204_default_1403455990838_73500' --output ubuntu-server-12.04-chef.box
    ==> Ubuntu-Server-1204_default_1403455990838_73500: Attempting graceful shutdown of VM...
    ==> Ubuntu-Server-1204_default_1403455990838_73500: Clearing any previously set forwarded ports...
    ==> Ubuntu-Server-1204_default_1403455990838_73500: Exporting VM...
    ==> Ubuntu-Server-1204_default_1403455990838_73500: Compressing package to: /Users/einternicola/code/vagrant-vms/Ubuntu-Server-12.04/ubuntu-server-12.04-chef.box

    $ vagrant box add Ubuntu-Server-12.04-chef file://$(pwd)/ubuntu-server-12.04-chef.box                                          [10:59:23]
    ==> box: Adding box 'Ubuntu-Server-12.04-chef' (v0) for provider:
        box: Downloading: file:///Users/einternicola/code/vagrant-vms/Ubuntu-Server-12.04/ubuntu-server-12.04-chef.box
    ==> box: Successfully added box 'Ubuntu-Server-12.04-chef' (v0) for 'virtualbox'!

    $ vagrant box list
    Ubuntu-Server-12.04      (virtualbox, 0)
    Ubuntu-Server-12.04-chef (virtualbox, 0)
    amazon-linux             (virtualbox, 0)
    centos-6.4               (virtualbox, 0)
    centos-6.4-chef          (virtualbox, 0)
    lucid                    (virtualbox, 0)
