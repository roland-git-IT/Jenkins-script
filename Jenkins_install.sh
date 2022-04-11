#!/bin/bash

# Description: Jenkins Installation script
# Author: Roland Udo-Akang
# Date: 4/10/2022

echo "Jenkins installation beginning..."

curl ifconfig.me > /dev/null 2>&1
if [ $? -ne 0 ]
then
echo "No internet connection..."
exit
else
echo "Installing Java..."
sudo yum install java-1.8.0-openjdk-devel -y > /dev/null 2>&1
if [ $? -eq 0 ]
then
echo "Java installed successfully!"
else
echo "Unable to install java."
exit
fi

echo "Enabling Jenkins repository..."
rpm -q wget > /dev/null 2>&1
if [ $? -ne 0 ]
then
echo "Installing wget package..."
sudo yum install wget -y > /dev/null 2>&1
fi
echo "Downloading jenkins repository..."
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
echo "disabling key check..."
sudo sed -i 's/gpgcheck=1/gpgcheck=0/g' /etc/yum.repos.d/jenkins.repo
if [ $? -eq 0 ]
then
echo "Repository enabled successfully!"
else
echo "Unable to enable repository."
exit
fi

echo "Installing the lates stable version of Jenkins..."
sudo yum install jenkins -y > /dev/null 2>&1
echo "Starting and enabling Jenkins service..."
systemctl start jenkins
systemctl enable jenkins

echo "finishing setup..."
sudo systemctl status firewalld
if [ $? -ne 0 ]
then
systemctl start firewalld
fi
sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp
sudo firewall-cmd --reload
fi

echo -e "done!!\nThank you for your patience."
echo -e "Go on you browser and type in your address bar as follows to complete setup:\n$(hostname -I|awk '{print $2}'):8080"
