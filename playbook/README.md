The easiest way to install MongoDB and use the mongod command on ubuntu 18.04.

Update the packages list.

 $ sudo apt update
Install the MongoDB.

 $ sudo apt install -y mongodb
Check the service's status.

 $ sudo systemctl status mongodb
3a. You should see

 ● mongodb.service - An object/document-oriented database
   Loaded: loaded (/lib/systemd/system/mongodb.service; enabled; vendor 
   preset:enabled)
   Active: active (running) since Sat 2019-03-11 10:45:01 UTC; 4min 13s ago
   Docs: man:mongod(1)
   Main PID: 2312 (mongod)
   Tasks: 23 (limit: 1153)
   CGroup: /system.slice/mongodb.service
         └─2312 /usr/bin/mongod --unixSocketPrefix=/run/mongodb --config
   /etc/mongodb.conf
To allow access to MongoDB on its default port 27017

  $ sudo ufw allow 27017
Check status

  $ sudo ufw status
5a. You should see

     Status: active
     To                         Action      From
     --                         ------      ----
     27017                      ALLOW       Anywhere
     27017 (v6)                 ALLOW       Anywhere (v6)
5b. If it returns inactive

     $ sudo ufw enable

     Output:
     Firewall is active and enabled on system startup.
Check the / directory to see if there is a data/db directory, if not:

  $ sudo mkdir -p /data/db
To run the mongod first you need stop mongodb:

  $ sudo systemctl stop mongodb
Finally, you can run the mongod:

  $ sudo mongod