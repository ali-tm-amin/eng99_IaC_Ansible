
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


step 1: 3 machines running

step 2: ssh into controller

step 3: update and upgrade

If it doesn’t run update and upgrade ie no internet do step 4 & 5 
step 4: reload controller VM

step 5: repeat steps for agent nodes
step 6: run the provisioning file ./controller_config.sh
Step7: from the controller run update and upgrade
ansible all -a "sudo apt-get update -y" from controller vm
ansible all -a "sudo apt-get upgrade -y" from controller vm

## Ansible playbook
- Playbooks are reusable
- How can we create/write playbooks?
- Playbooks are written in YAML
- YAML used with ansible - cloud formation (AWS IaC), Docker compose, Kubernetes, and more
- YAML syntax and ext: file.yml and file.yaml, file.yml start with ---- three dashes

### Creating yml file
- From the controller VM cd /etc/ansible then run `sudo nano install_nginx.yml`
- Write the codes below:

    #this file is to conggure and install nginx in web agent node
    ---
    #Which host do we need to install nginx in
    - hosts: web
      gather_facts: true

    #WHat facts do we want to see while installing
      
    #Do we need admin access? yes
      become: true

    #What task do we wnt to perform in this tml file
      tasks:
      - name: install Nginx in web Agent Node
        apt: pkg=ngix state=present
        become_user: root
    #What is the end goal for this task
![](/images/yml_file.png)

- Run the file `ansible-playbook install_nginx.yml`
![](/images/playbook_nginx.png)

- Run adhoc command `ansible web -a "sudo systemctl status nginx"`
![](/images/nginx_status.png)

#### Task:
- Create a playbook to install nodejs in web node
- copy the app folder
- npm install then npm start
- end goal to see node running in our browser port 3000 
-Ceating playbook file: `sudo nano install_nodejs.yml`
![](/images/nodejs_yml.png)

- ansible-playbook install_nodejs.yml
![](/images/node_playbook.png)

- SSH into app from controller `ssh vagrant@192.168.56.10`
- cd app then run `npm start`
- Check the app running on browser
![](/images/port3000.png)

## IaC configuration management tools are used for push config managemnet and pull config managements?

