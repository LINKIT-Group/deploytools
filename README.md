
## Prepare:
1. clone this project
```git clone https://github.com/LINKIT-Group/deployscript.git```

2. setup credentials for AWS
You require an AWS account and setup an Access Key for your user and put this in your home-directory. Note, currently only AWS is supported for the remotestate backend.
cat ~/.aws/credentials 
```[default]
aws_access_key_id = ${YOUR_ACCESS_KEY_ID}
aws_secret_access_key = ${YOUR_SECRET_ACCESS_KEY}```

## Pull-merge a GIT repository into ./build/buildrepo
```make git url=${GIT_REPO}```

## Create remotestate (on AWS) and Terraform backend file
Create a remote state backend on AWS (two DynamoDB tables, and an S3 bucket) for the pulled ${GIT_REPO} from previous section. One set of DynamoDB/S3 will be created per GIT_HOST/GROUP combination (example "https://github.com/LINKIT-Group"), so multiple repositories in a group share a DynamoDB/S3 set.

```make remotestate```
