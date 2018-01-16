pipeline {
  agent {
    label 'swarm-agent'
  }
  environment {
     PROJECT_NAME = "jenkins-packer"
  }
  stages {
    stage('Packer Build') {
      steps {
        script {
          withCredentials([usernamePassword(credentialsId: 'secured', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
            sh """
               docker run --rm -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY -e AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION} -e AWS_VPC_ID=${AWS_VPC_ID} -e AWS_SUBNET_ID=${AWS_SUBNET_ID} -e AWS_SECURITY_GROUP_ID=${AWS_SECURITY_GROUP_ID} -v ${WORKSPACE}:/packer:rw hashicorp/packer:light build -var 'pwd=/packer' /packer/docker-aws.json
            """
          }
        }
      }
    }

  }
}

