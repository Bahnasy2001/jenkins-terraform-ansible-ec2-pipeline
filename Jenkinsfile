pipeline {
  agent any
  environment {
    AWS_REGION = 'eu-central-1'
    SSH_PUBLIC_KEY = credentials('my-ssh-public-key')
  }
  stages {
    stage('Terraform Init & Apply') {
      steps {
        withCredentials([[
          $class: 'AmazonWebServicesCredentialsBinding', 
          credentialsId: 'aws-creds'
        ]]) {
          sh '''
            echo "$SSH_PUBLIC_KEY" > /tmp/my-jenkins-key.pub
            aws ec2 import-key-pair --key-name "my-jenkins-key" --public-key-material fileb:///tmp/my-jenkins-key.pub --region eu-central-1 || true
            cd terraform
            terraform init
            terraform apply -auto-approve -var "public_key_path=/tmp/my-jenkins-key.pub"
          '''
        }
      }
    }

    stage('Wait for EC2 Ready') {
        steps {
            withCredentials([[ 
            $class: 'AmazonWebServicesCredentialsBinding', 
            credentialsId: 'aws-creds' 
            ]]) {
            sh '''
                INSTANCE_ID=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=Jenkins-Terraform-EC2" --query "Reservations[*].Instances[*].InstanceId" --output text)
                aws ec2 wait instance-status-ok --instance-ids $INSTANCE_ID --region $AWS_REGION
            '''
            }
        }
    }
    stage('Ansible Configure EC2') {
      steps {
        withCredentials([
          [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds'],
          sshUserPrivateKey(credentialsId: 'ansible-ssh-key', keyFileVariable: 'ANSIBLE_PRIVATE_KEY')
        ]) {
          sh '''
            cd ansible
            ansible-inventory -i aws_ec2.yaml --list
            ansible-playbook -i aws_ec2.yaml playbook.yml --private-key $ANSIBLE_PRIVATE_KEY
          '''
        }
      }
    }
  }
}
