# Jenkins Installation

This repo contains simple commands to install and configure Jenkins on an AWS EC2 Amazon Linux machine.

## EC2 setup assumptions

- Amazon Linux EC2 instance
- Port `22` open for SSH from your IP
- Port `8080` open for Jenkins from your IP
- Java 17 installed or installed during setup

## Connect to EC2

```bash
ssh -i key.pem ec2-user@YOUR_EC2_PUBLIC_IP
```

If your username is different, replace `ec2-user` with the correct user.

## Install Jenkins on Amazon Linux

```bash
sudo dnf update -y
sudo dnf install -y fontconfig java-17-amazon-corretto curl
java -version

sudo wget -O /etc/yum.repos.d/jenkins.repo \
  https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

sudo dnf install -y jenkins
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

## Connect Jenkins to GitHub

### Create a pipeline job

1. In Jenkins, click **New Item**
2. Enter a name like `jenkins-installation-pipeline`
3. Select **Pipeline**
4. Click **OK**

### Point Jenkins to your GitHub repo

In the pipeline job configuration:

- Under **Pipeline**, choose **Pipeline script from SCM**
- SCM: **Git**
- Repository URL:

```text
https://github.com/karanjashan49-beep/Jenkins-installation.git
```

- Branch specifier:

```text
*/main
```

- Script path:

```text
Jenkinsfile
```

Then click **Save**.

### Run the pipeline

- Open the pipeline job
- Click **Build Now**
- Open **Console Output** to see each stage

## GitHub webhook setup

To trigger Jenkins automatically when code is pushed:

### In Jenkins job

1. Open the job
2. Click **Configure**
3. Under **Build Triggers**, enable:
   - **GitHub hook trigger for GITScm polling**
4. Save

### In GitHub repo

1. Open the repo:
   `https://github.com/karanjashan49-beep/Jenkins-installation`
2. Go to **Settings** -> **Webhooks** -> **Add webhook**
3. Payload URL:

```text
http://YOUR_EC2_PUBLIC_IP:8080/github-webhook/
```

4. Content type:

```text
application/json
```

5. Choose:
   - **Just the push event**
6. Click **Add webhook**

## Optional next steps

After Jenkins works, you can connect:

- your real GitHub project repo
- webhooks for auto-builds
- a better Jenkinsfile for your app
- deployment steps to EC2 or another server
