sudo apt-get update -y
sudo apt-get upgrade -y
ls
./controller_config.sh
sudo ansible all -a "sudo apt update -y"
cd /ect
ls
cd /etc
cd ansible
ls
sudo ansible all -a "sudo apt update -y"
ls -la
cat ansible.cfg 
ssh vagrant@192.168.56.10
sudo apt-get upgrade -y
sudo apt-get update -y
ls -la
ls
sudo ansible all -m ping
ls
cd
ls
cd /etc/ansible
ls
sudo nano hosts
ls
sudo ansible all -m ping
sudo apt-get update -y
sudo apt-get upgrade -y
ping google.com
chmod +x controller_config.sh
chmod +x .controller_config.sh
sudo chmod +x /.controller_config.sh
./controller_config.sh
ls
cd
ls
chmod controller_config.sh
chmod +x controller_config.sh
./controller_config.sh
ls
cd /etc
cd ansible
ls
cd
ls
sudo ./controller_config.sh
cd /etc
cd ansible/
ls
cd
ls
chmod x+ controller_config.sh
clear
which ansible
ansible --version
./controller_config.sh
exit
ls
chmod +x controller_config.sh 
./controller_config.sh 
cd /etc
cd ansible/
ls
ls
clea
clear
ls
cd
ls
./controller_config.sh 
ansible --version
cd 
   
# mongodb_setup.yml
# Note - Ensure the node-app and mongodb required dependencies are available in the specified location
---
    - hosts: db
    
      gather_facts: yes
    
      become: true
    
      tasks:
      - name: install mongodb
        apt: pkg=mongodb state=present
    
      - name: Remove mongodb file (delete file)
        file:
          path: /etc/mongodb.conf
          state: absent
    
      - name: Touch a file, using symbolic modes to set the permissions (equivalent to 0644)
        file:
          path: /etc/mongodb.conf
          state: touch
          mode: u=rw,g=r,o=r
    
    
      - name: Insert multiple lines and Backup
        blockinfile:
          path: /etc/mongodb.conf
          block: |             storage:
              dbPath: /var/lib/mongodb
              journal:
                enabled: true
            systemLog:
              destination: file
              logAppend: true
              path: /var/log/mongodb/mongod.log
            net:
              port: 27017
              bindIp: 0.0.0.0
      - name: Restart mongodb
        become: true
        shell: systemctl restart mongodb
    
      - name: enable mongodb
        become: true
        shell: systemctl enable mongodb
    
      - name: start mongodb
        become: true
ls
cd /etc
cd ansible
ls
clear
ls -la
cd 
cd controller_config.sh 
ls
./controller_config.sh 
cd /etc
cd ansible/
ls
cat hosts
cd
ssh vagrant@192.168.56.10
ssh vagrant@192.168.56.11
ls
clear
sudo ansible all -m ping
cd /etc/ansible
sudo ansible all -m ping
ls
sudo ansible web -m ping
sudo ansible db -m ping
sudo ansible -a "sudo apt update -y"
sudo ansible web -a "sudo apt update -y"
ansible all -a "sudo apt-get update -y"
ansible web -a "free"
ping google.com
ping 192.168.56.10
ping 192.168.56.11
clear
ansible all -a "echo hello"
sudo nano hosts
ansible web -a "sudo apt-get update -y"
cd 
exit
ls
ssh vagrant@192.168.56.10
ssh vagrant@192.168.56.11
cat controller_config.sh 
./controller_config.sh 
cd /etc/ansible/
ls
ansible all -a "echo all"
sudo apt-get install sshpass
ansible all -a "echo all"
nano /home/vagrant/.ssh/known_hosts
cd
exit
