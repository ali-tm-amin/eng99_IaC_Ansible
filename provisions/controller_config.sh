
   
# Update
sudo apt-get update -y
sudo apt-get upgrade -y

# Install
sudo apt-get install software-properties-common
sudo add-repository ppa:ansible/ansible -y
sudo apt-get install ansible -y
sudo apt-get install sshpass 
# replace file  /etc/ansible/hosts

sudo rm -rf /etc/ansible/hosts

sudo cp controller/hosts /etc/ansible/hosts

# to make sure we get the key, otherwise will have to ssh into agents first before running adhoc commands
ssh-keyscan -H 192.168.56.10>>~/.ssh/known_hosts
ssh-keyscan -H 192.168.56.11>>~/.ssh/known_hosts