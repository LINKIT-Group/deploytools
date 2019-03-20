
## Prepare
### Prerequisites
1. Linux-, Mac- or Unix-based system
2. Docker deamon. Install instructions: [Ubuntu](https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce) / [Mac](https://docs.docker.com/docker-for-mac/install/)
3. Docker compose script, [instructions here](https://docs.docker.com/compose/install/)
4. functionally complete shell. Ability to create new Docker containers (2, 3), run "git" and "make". All else happens in container-space
5. an AWS account to create a DynamoDB-S3 pair (remote state backend)

### Related
1. The Docker & Makefile configuration is based upon [this article](https://itnext.io/docker-makefile-x-ops-sharing-infra-as-code-parts-ea6fa0d22946).

2. Python3 module to merge multiple GIT repos into a buildrepo: https://github.com/LINKIT-Group/makegit
3. Python3 module to create remote state backend: https://github.com/LINKIT-Group/remotestate

### WYSIWYG


### clone this project
```
git clone https://github.com/LINKIT-Group/deployscript.git
```

### setup credentials for AWS
An AWS account is required to setup an Access Key for your user and put this in your home-directory. Note, currently only AWS is supported for the remotestate backend.
cat ~/.aws/credentials 
```
[default]
aws_access_key_id = ${YOUR_ACCESS_KEY_ID}
aws_secret_access_key = ${YOUR_SECRET_ACCESS_KEY}
```

## Pull-merge a GIT repository into ./build/buildrepo
```
make git url=${GIT_REPO}
```

## Create remotestate (on AWS) and Terraform backend file
Create a remote state backend on AWS (two DynamoDB tables, and an S3 bucket) for the pulled ${GIT_REPO} from previous section. One set of DynamoDB/S3 will be created per GIT_HOST/GROUP combination (example "https://github.com/LINKIT-Group"), so multiple repositories in a group share a DynamoDB/S3 set.

```
make remotestate
```
