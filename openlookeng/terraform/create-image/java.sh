#!/bin/bash

yum --showduplicate list java*


yum install -y java-1.8.0-openjdk-1.8.0.282.b08-1.el7_9.x86_64
yum install -y java-1.8.0-openjdk-devel-1.8.0.282.b08-1.el7_9.x86_64

#Install git
yum install -y git


mvnpath=/usr/local/maven

if [ ! -d "$mvnpath" ]; then
    echo "Creating directory $mvnpath"
    sudo mkdir $mvnpath
    echo "$mvnpath Directory created successfully"
fi


echo "Downloading maven installation package, please wait. ..."



wget https://repo.huaweicloud.com/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz

mvnfile=$(ls | grep apache*maven-*.gz)

echo "source /etc/profile" >> ~/.bashrc

if [ -f "$mvnfile" ]; then


    tar zxvf $mvnfile -C $mvnpath


    mvnpath=$mvnpath/apache-maven-3.6.3/bin
    echo "Maven installed successfully"
    echo "Configure environment variables"

    echo "export MAVEN_HOME=/usr/local/maven/apache-maven-3.6.3/bin" >> /etc/profile

    echo "export PATH=$mvnpath:$PATH" >> /etc/profile
    echo "Installation succeeded"
    source /etc/profile

else
    echo "Maven file not found"
fi
source /etc/profile

#Install docker and set it to boot itself
yum -y install yum-utils device-mapper-persistent-data lvm2

yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

yum makecache fast
yum -y install docker-ce


systemctl start docker
systemctl enable docker



cp ./daemon.json /tmp/
cp /tmp/daemon.json /etc/docker/
service docker restart

docker pull mysql:8.0.15
docker pull prestodb/hdp2.6-hive
docker pull testcontainers/ryuk:0.3.0
docker pull mongo:3.4.0
docker pull enmotech/opengauss:1.1.0
docker pull microsoft/mssql-server-linux:2017-CU13
cp ./id_rsa /tmp/
cp ./id_rsa.pub /tmp/

cp ./maven.sh /tmp/
