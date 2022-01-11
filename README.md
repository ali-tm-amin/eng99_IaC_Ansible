
# IAC with Ansible

![](/IaC_ansible.png)
## Let's create Vagrantfile to create Three VMs for Ansible architecture
### Ansible controller and Ansible agents


#### Vagrant up

1. From the vagrant directory set up all 3 VMs with `vagrant up` command

2. Run update and upgrade commands for each VMs

- SSH into controller `vagrant ssh controller`, default password is `vagrant`


- `sudo apt update -y`

- `sudo apt upgrade -y`

- Exit controller and ssh into web `vagrant ssh web` and db `vagrant ssh db` and repeate update and upgrade

3. A- Setting up ansible controller
- These are provisioned and copied into Vagrantfile
  - controller.vm.synced_folder "./provisions", "/home/vagrant/controller"

4. B- Accessing the other instances through the controller:
- Navigate to /etc/ansible
- Remove origin_hosts and create new one `sudo nano hosts`
- Add these to the file and save it

  [web]
  192.168.56.10 ansible_connection=ssh ansible_ssh_user=vagrant ansible_ssh_pass=vagrant
  [db]
  192.168.56.11 ansible_connection=ssh ansible_ssh_user=vagrant ansible_ssh_pass=vagrant
      
- To access other instances through controller manually `ssh vagrant@192.168.56.10`
- To do it remotey through controller we need add these lines to make it known host

    ssh-keyscan -H 192.168.56.10 >> ~/.ssh/known_hosts
    ssh-keyscan -H 192.168.56.11 >> ~/.ssh/known_hosts


4. Now you can adhoc commands:

ping all servers with a single command
- To know what servers we have
-  Ping all `sudo ansible all -m ping`

- Identify current systems `sudo ansible all -a "uname -a"`

- The server `sudo ansible all -a "whoami"`

- Date and time `sudo ansible all -a "date"`

- Free space `sudo ansible web -a "free"`


- All facts `sudo ansible all -m ansible.builtin.setup`


### Reload the VMs

step 1: 3 machines running

step 2: ssh into controller

step 3: update and upgrade

If it doesn’t run update and upgrade ie no internet do step 4 & 5 
step 4: reload controller VM

step 5: repeat steps for agent nodes

step 6: run the provisioning file inside controller folder `./controller_config.sh`

Step7: from the controller run update and upgrade
`sudo ansible all -a "sudo apt update -y"` from controller vm
`sudo ansible all -a "sudo apt upgrade -y"` from controller vm

## Ansible playbook
- Playbooks are reusable
- How can we create/write playbooks?
- Playbooks are written in YAML
- YAML used with ansible - cloud formation (AWS IaC), Docker compose, Kubernetes, and more
- YAML syntax and text: file.yml and file.yaml, file.yml start with (---) three dashes

### Creating yml file
- From the controller VM cd /etc/ansible then run `sudo nano nginx.yml`

![](/images/yml_file.png)

- Run the file `sudo ansible-playbook nginx.yml`

![](/images/playbook_nginx.png)

- Run adhoc command `sudo ansible web -a "sudo systemctl status nginx"`

![](/images/nginx_status.png)

#### Task:
- Create a playbook to install nodejs in web node
- copy the app folder
- npm install then npm start
- end goal to see node running in our browser port 3000 
-Ceating playbook file: `sudo nano nodejs.yml`

![](/images/nodejs_yml.png)

- Run the file `sudo ansible-playbook nodejs.yml`

![](/images/node_playbook.png)

- SSH into app from controller `ssh vagrant@192.168.56.10`
- cd app then run `npm start`
- Check the app running on browser

![](/images/port3000.png)

### Installing mongodb
- Creating playbook file `sudo nano mongo.yml`

![](/images/mongo_yml.png)

- Check for any errors `sudo ansible-playbook mongo.yml --syntax-check`
- Run the playbook `sudo ansible-playbook mongo.yml`
- Check mongodb status `sudo ansible db -a "systemctl status mongodb"`

![](/images/mongodb_status.png)

- Now ssh into db and configure mongodb `ssh vagrant@192.168.56.11`
- cd /etc then `sudo nano mongodb.conf` and channge the bind_ip to `0.0.0.0`

- Then restart and enable mongodb 
    sudo systemctl restart mongodb
    sudo systemctl enable mongodb

- SSH into web and configure .bashrc and add 

      - export DB_HOST="mongodb://192.168.56.10:27017/posts"  
      - source ~/.bashrc  
      - printenv DB_HOST
      - Cd app and seed node: node seeds/seed.js
      - then npm start and check the browser if the app is running



### Importing playbooks
    ---
    #Run Mongodb Playbook
    - name: Running MongoDB Playbook
      import_playbook: mongo.yml

    #Run Nginx Playbook
    - name: Running Nginx Playbook
      import_playbook: nginx.yml

#### SSH into aws app through controller

- We need to have the eng99.pem to be able ssh to aws ec2
- To copy the eng99.pem folder from local to vagrant follow these comands below:

      - first `vagrant plugin install vagrant-scp`
      - then `vagrant scp <some_local_file_or_dir> [vm_name]:<somewhere_on_the_vm>`

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
 - Checking installation 
 - `aws --version`
 - Outcome should be as 
 - `aws-cli/1.20.40 Python/3.6.9 Linux/4.15.0-151-generic botocore/1.21.40`

- Let's change python to use python3

- `alias python=python3`

- then needs to run terraform apply to get instances running
- sudo ssh -i "~/.ssh/eng99.pem" ubuntu@ip..
- or cd ~/.ssh then ssh into mechine
- `sudo apt update -y`

#### Let's create Ansible vault file to secure our AWS keys

- cd `/etc/ansible` then create a folder 
- `sudo mkdir group_vars`
- cd group_vars then create a nother folder 
- `sudo mkdir all`, then `cd all`
- then run `sudo ansible-vault create pass.yml`
- aws_access_key and aws_secret_key copy your keys
- to save the file press `esc` then type `:wq!` then enter
- for editing the file `ansible-vault edit pass.yml`
- Give permissions `sudo chmod 666 pass.yml`
- `sudo cat pass.yml` it's encrypted now
- change the hosts file and add aws ip 

      [aws]
      ec2-instance ansible_host=54.74.243.133 ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/eng99.pem
      [db]
      ec2-instance ansible_host=34.253.155.134 ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/eng99.pem

- ssh into aws instance and run update then exit and back to controller
- navigate to `/etc/ansibale` then
- now run 
- `sudo ansible aws -m ping --ask-vault-pass`


### Run playbooks

- Navigate to `/etc/ansible` then create and run the playbooks:
1. Create nodejs.yml 
- `sudo nano nodejs.yml`
- Run it
- `sudo ansible-playbook --ask-vault-pass nodejs.yml`

2. Create nginx.yml 
- `sudo nano nginx.yml`
- Run it
- `sudo ansible-playbook --ask-vault-pass nginx.yml`
3. Create mongo.yml 
- `sudo nano mongo.yml`
- Then run it 
- `sudo ansible-playbook --ask-vault-pass mongo.yml`
- Check nginx status
- `sudo ansible aws -a "sudo systemctl status nginx" --ask-vault-pass`

### IaC configuration management tools are used for push config managemnet and pull config managements