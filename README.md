# Sample of using packer to build an AMI

This is designed to be built in Jenkins via a Jenkinsfile. The AWS creds are stored in Jenkins and not kept in this code repo.

# Packer
The details of the resulting AMI are defined within docker-ami.json, which is a packer configuration file.

# Manually running
* export the necessary variables into your environment and then run the following:
```
docker run --rm -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY -e AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION} -e AWS_VPC_ID=${AWS_VPC_ID} -e AWS_SUBNET_ID=${AWS_SUBNET_ID} -e AWS_SECURITY_GROUP_ID=${AWS_SECURITZY_GROUP_ID} -v ${WORKSPACE}:/packer:rw hashicorp/packer:light build -var 'pwd=/packer' /packer/docker-aws.json
```

This runs packer from within a container to forego needing to install packer on your build machine.
