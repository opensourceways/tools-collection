#!/bin/bash



echo "127.0.0.1       hadoop-master" >> /etc/hosts
yum -y install expect

user="openlookeng"
password="ab123@123ab"
fullname="jack"
chmod 0440 /etc/sudoers

useradd -m $user


echo $user:$password|chpasswd


chmod 777 /etc/sudoers
echo "openlookeng    ALL=(ALL:ALL) ALL"  >> /etc/sudoers
chmod 0440 /etc/sudoers

sudo groupadd docker
sudo gpasswd -a openlookeng docker
sudo service docker restart
  
su - openlookeng <<EOF


#Determine whether the folder exists
if [ ! -d .ssh/ ];then
  mkdir .ssh/
else
  echo "Folder already exists"
fi


cp /tmp/id_rsa.pub  .ssh/

cp /tmp/id_rsa  .ssh/
chmod 600 .ssh/id_rsa
chmod 644 .ssh/id_rsa.pub

source /etc/profile

cp /tmp/maven.sh ./
chmod +x ./maven.sh
sh maven.sh


/usr/bin/expect <<-EF
spawn ssh -T git@gitee.com
expect {

   "yes/no" {send "yes\n"}

}
expect eof
EF



git clone git@gitee.com:openlookeng/hetu-core.git
if [ $? -ne 0 ]; then
    echo "Failed to pull hetu-core"
else
    echo "Get hetu-core successfully"
fi


git clone git@gitee.com:openlookeng/hetu-maven-plugin.git

if [ $? -ne 0 ]; then
    echo "Failed to pull hetu-maven-plugin"
else
    echo "Get hetu-maven-plugin successfully"
fi

chmod 700 .ssh
cat .ssh/id_rsa.pub >> .ssh/authorized_keys
chmod 600 .ssh/authorized_keys

cd hetu-maven-plugin
mvn clean install -DskipTests
cd ..


cd hetu-core

mvn clean install -DskipTests


#mvn test -pl '!hetu-server,!hetu-server-rpm'

cd ..

rm -rf hetu-core
rm -rf hetu-maven-plugin


git config --global user.name "abc"
git config --global user.email "abc@example.com"

exit

EOF


rm /tmp/id_rsa
rm /tmp/id_rsa.pub

git config --global user.name "abc"
git config --global user.email "abc@example.com"

