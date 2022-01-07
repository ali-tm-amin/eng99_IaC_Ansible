
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

step 6: run the provisioning file `./controller_config.sh`

Step7: from the controller run update and upgrade
`ansible all -a "sudo apt-get update -y"` from controller vm
`ansible all -a "sudo apt-get upgrade -y"` from controller vm

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

### Installing mongodb
- Creating playbook file `sudo nano install_mongo.yml`
![](/images/mongo_yml.png)
- Check for any errors `ansible-playbook install_mongo.yml --syntax-check`
- Run the playbook `ansible-playbook install_mongo.yml`
- Check mongodb status `ansible db -a "systemctl status mongodb"`
![](/images/mongodb_status.png)
- Now ssh into db and configure mongodb `ssh vagrant@192.168.56.11`
- cd /etc then `sudo nano mongodb.conf` nad channge the bind_ip to `0.0.0.0`

- Then restart and enable mongodb 
    sudo systemctl restart mongodb
    sudo systemctl enable mongodb

- SSH into web and configure .bashrc and add `export DB_HOST="mongodb://192.168.56.11:27017/posts"` then `source ~/.bashrc` and check print `printenv DB_HOST`
- Cd app seed node `node seeds/seed.js`
- then `npm start` and check the browser
## IaC configuration management tools are used for push config managemnet and pull config managements?


-----

### Importing playbooks
  ---
  #Run Mongodb Playbook
  - name: Running MongoDB Playbook
    import_playbook: mongodb.yml

  #Run Nginx Playbook
  - name: Running Nginx Playbook
    import_playbook: nginx_proxy.yml
#### SSH into aws app through controller
- We need to have the eng99.pem to be able ssh to aws ec2
- We need to install dependencies to set up Ansible Vault to secure our AWS access and secret keys
- Let's install the them using the script
        
        !#/bin/bash
        sudo apt update -y
        sudo apt-get install tree -y
        sudo apt-add-repository --yes --update ppa:ansible/ansible
        sudo apt install ansible -y
        sudo apt install python3-pip

        pip3 install awscli 
        pip3 install boto boto3 -y
        sudo apt-get upgrade -y
 - Checking installation `aws --version`
 - Outcome should be as `aws-cli/1.20.40 Python/3.6.9 Linux/4.15.0-151-generic botocore/1.21.40`

- Let's change python to use python3

- `alias python=python3`

- then needs to run terraform apply to get instances running
- sudo ssh -i "~/.ssh/eng99.pem" ubuntu@ip..
- or cd ~/.ssh then ssh into mechine
- `sudo apt update -y`
#### Let's create Ansible vault file to secure our AWS keys

- cd `/etc/ansible` then create a folder `sudo mkdir group_vars`
- cd group_vars then create a nother folder 
- `sudo mkdir all`, then `cd all`
- run `sudo ansible-vault create pass.yml`
- aws_access_key and aws_secret_key copy your keys
- to save the file press `esc` then type `:wq!` then enter
- for editing the file `ansible-vault edit pass.yml`
- `sudo cat pass.yml` it's encrypted now
- change the hosts file and add aws ip 

    [aws]
    ec2-instance ansible_host=54.74.243.133 ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/eng99.pem
    [db]
    ec2-instance ansible_host=34.253.155.134 ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/eng99.pem

- ssh into aws instance and run update then exit and back to controller
- navigate to `/etc/ansibale` then
- now run `ansible aws -m ping --ask-vault-pass`
- `sudo chmod 666 pass.yml`
### Run playbooks
- Navigate to `/etc/ansible` then create and run the playbooks:
1. Create nodejs.yml `sudo nano pass.yml nodejs.yml`
- Run it `sudo ansible-playbook --ask-vault-pass nodejs.yml`
2. Create nginx.yml `sudo nano pass.yml nginx.yml`
- Run it`sudo ansible-playbook --ask-vault-pass nginx.yml`
3. Create mongo.yml `sudo nano pass.yml mongo.yml`
- Then run it `sudo ansible-playbook --ask-vault-pass mongo.yml`
- Check nginx status `sudo ansible aws -a "sudo systemctl status nginx" --ask-vault-pass`