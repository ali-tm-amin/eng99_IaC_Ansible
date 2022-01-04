
# IAC with Ansible

![](/IaC_ansible.png)
## Let's create Vagrantfile to create Three VMs for Ansible architecture
### Ansible controller and Ansible agents


#### Vagrant up

1. From the vagrant directory set up all 3 VMs with `vagrant up` command

2. Run update and upgrade commands for each VMs

- SSH into controller `vagrant ssh controller`


- `sudo apt-get update -y`

- `sudo apt-get upgrade -y`

- Exit controller and ssh into web and db and repeate above process
3. Setting up ansible controller
- These are provisioned and copied into Vagrantfile
  - controller.vm.synced_folder "./provisions", "/home/vagrant/controller"
     
4. Now you can adhoc commands:

ping all servers with a single command
- To know what servers we have `sudo ansible all -m ping`

- `ansible web -a "uname -a"`

- `ansible all -a "uname -a"`

- `ansible all -a "whoami"`

- `ansible all -a "date"`

- `ansible web -a "free"`


- All facts `ansible all -m ansible.builtin.setup`

