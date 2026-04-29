#!/usr/bin/env bash
set -euo pipefail

sudo apt update
sudo apt install -y fontconfig openjdk-17-jre curl
java -version

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt update
sudo apt install -y jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins --no-pager

echo
echo 'Initial Jenkins admin password:'
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
