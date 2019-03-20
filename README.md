
## Prerequisites
1. Linux-, Mac- or Unix-based system.
2. Docker deamon. Install instructions: [Ubuntu](https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce) / [Mac](https://docs.docker.com/docker-for-mac/install/).
3. Docker compose script, [instructions here](https://docs.docker.com/compose/install/).
4. Functionally complete shell. Able to create new Docker containers (2, 3), run "git" and "make". Git is only used once on the host, to clone this project. Make is used for firing up docker oneliners, all work gets done in container-space so there are no additional application dependencies for the host.
5. an AWS account to create a DynamoDB-S3 pair (remote state backend).


## WYSIWYG
![Deploy with State](https://github.com/LINKIT-Group/deployscript/raw/master/deploy-with-state-v2.png)


## Prepare
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

## Usage
Note: at first run a Docker image will be build, this can take a few minutes. Subsequent runs are much faster.
### Pull-merge a GIT repository into ./build/buildrepo
```
make git url=${GIT_REPO}
```

### Create remotestate (on AWS) and Terraform backend file
Create a remote state backend on AWS (two DynamoDB tables, and an S3 bucket) for the pulled ${GIT_REPO} from previous section. One set of DynamoDB/S3 is created per GIT_HOST/GROUP combination (example "https://github.com/LINKIT-Group"), multiple repositories in a group share a DynamoDB/S3 set.

```
# create a remote state backend for git-repo in ./build/buildrepo
make remotestate
```

### Cleanup
```
# WARNING: this function will be changed soon, with additions to prevent un-commited work getting lost.
# clear ./build directory (wip: removal of container image)
make clean
```

## Related
### Docker & Makefile
Makefile configuration is based upon [this article](https://itnext.io/docker-makefile-x-ops-sharing-infra-as-code-parts-ea6fa0d22946)

### Python modules: makegit and remotestate
These two modules are installed automatically in the docker container, see Dockerfile.
- makegit, to merge multiple GIT repos into a buildrepo. Source: https://github.com/LINKIT-Group/makegit
- remotestate, to create a remote state backend. Source: https://github.com/LINKIT-Group/remotestate
