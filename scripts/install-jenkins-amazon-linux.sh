#!/usr/bin/env bash
set -euo pipefail

sudo dnf update -y
sudo dnf install -y fontconfig java-17-amazon-corretto curl wget
java -version

sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

sudo dnf install -y jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins --no-pager

echo
echo 'Initial Jenkins admin password:'
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
