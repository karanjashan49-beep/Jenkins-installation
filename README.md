# Jenkins Installation

This repo contains simple commands to install and configure Jenkins on an AWS EC2 Ubuntu machine.

## EC2 setup assumptions

- Ubuntu-based EC2 instance
- Port `22` open for SSH from your IP
- Port `8080` open for Jenkins from your IP
- Java 17 installed or installed during setup

## Connect to EC2

```bash
ssh -i key.pem ubuntu@YOUR_EC2_PUBLIC_IP
```

If your username is different, replace `ubuntu` with the correct user.

## Install Jenkins on Ubuntu

```bash
sudo apt update
sudo apt install -y fontconfig openjdk-17-jre
java -version

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt update
sudo apt install -y jenkins
```

## Start and enable Jenkins

```bash
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins
```

## Check Jenkins in browser

Open:

```text
http://YOUR_EC2_PUBLIC_IP:8080
```

## Get initial admin password

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

Copy that password into the Jenkins browser setup page.

## First-time Jenkins UI setup

1. Open Jenkins URL
2. Paste initial admin password
3. Click **Install suggested plugins**
4. Create admin user
5. Save and continue

## Fix executor issue if jobs stay queued

If Jenkins says **Waiting for next available executor**:

1. Open **Manage Jenkins**
2. Open **Nodes**
3. Click **Built-In Node**
4. Click **Configure**
5. Set **Number of executors** to `1`
6. Save
7. Go back and click **Build Now**

## Create a test job

1. Click **New Item**
2. Enter a job name
3. Select **Freestyle project**
4. Click **OK**
5. In **Build Steps**, choose **Execute shell**
6. Add:

```bash
echo "Jenkins is working"
date
whoami
pwd
```

7. Click **Save**
8. Click **Build Now**
9. Open **Console Output**

## Useful admin commands

Check Jenkins service:

```bash
sudo systemctl status jenkins
```

Restart Jenkins:

```bash
sudo systemctl restart jenkins
```

View recent logs:

```bash
sudo journalctl -u jenkins -n 100 --no-pager
```

Follow logs live:

```bash
sudo journalctl -u jenkins -f
```

## AWS security group recommendation

Inbound rules should be:

- SSH `22` -> **My IP**
- Custom TCP `8080` -> **My IP**

Avoid this:

- All traffic -> `0.0.0.0/0`

## Optional next step

After Jenkins works, you can connect:

- GitHub repository
- Webhooks
- Jenkinsfile pipeline
- Deployment steps
