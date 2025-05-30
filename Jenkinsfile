pipeline {
  agent any
  environment {
    AWS_REGION = 'eu-west-1'
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
            cd terraform
            terraform init
            terraform apply -auto-approve -var "public_key_path=/tmp/my-jenkins-key.pub"
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
