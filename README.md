### EC2 Instance Specs
- Ubuntu bionic 18.04LTS
- instance storage, we don't care about persisting storage state
- AMI, ami-0c0933478b3757789

#### EC2 AMI Lookup
Up to date list of all AWS Ubuntu images. 

Use this list to modify the current AMI's if needed.

http://cloud-images.ubuntu.com/locator/ec2/

### Kubernetes setup

##### Kubernetes on AWS

1. Install kubectl

`xcode-select --install`
`brew install kubernetes-cli`

2. Install VirtualBox


https://www.virtualbox.org/wiki/Downloads

3. Install Minikube

`brew cask install minikube`
this will now be on the terminal path and you can execute minikube


4. If you already installed the Docker Desktop app you need to run:
`rm /usr/local/bin/kubectl`
`brew link --overwrite kubernetes-cli`
This will remove the symlinks to the cli forced in the Docker.app not the installed cli
And also optionally:
`brew link --overwrite --dry-run kubernetes-cli`

Minikube Configuration
all the minikube configuration is in either` ~/.minikube` or `~/.kube` 
The main config file can be found here, `~./kube/config`


brew install wget
wget https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.4.0/aws-iam-authenticator_0.4.0_linux_amd64
rename to aws-iam-authenticator
mv /usr/local/bin/aws-iam-authenticator
