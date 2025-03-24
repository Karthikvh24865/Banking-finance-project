pipeline {
  agent any
   environment {
         AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
         AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY') 
   } 
  stages {
   stage('CheckOut') {
      steps {
        echo 'Checkout the source code from GitHub'
        git url: 'https://github.com/prabhulk25/Banking-finance-project'
            }
    }
    
    stage('Package the Application') {
      steps {
        echo " Packaing the Application"
        sh 'mvn clean package'
            }
    }
    
    stage('Publish Reports using HTML') {
      steps {
      publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: '/var/lib/jenkins/workspace/Banking-Project/target/surefire-reports', reportFiles: 'index.html', reportName: 'HTML Report', reportTitles: '', useWrapperFileDirectly: true])
            }
    }
    
    stage('Docker Image Creation') {
      steps {
        sh 'docker build -t prabhulk/bankingfinance .'
            }
    }
    stage('DockerLogin') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'Docker-Login', passwordVariable: 'docker_password', usernameVariable: 'docker_login')]) {
        sh "docker login -u ${docker_login} -p ${docker_password}"
            }
        }
    } 
  
    stage('Push Image to DockerHub') {
      steps {
        sh 'docker push prabhulk/bankingfinance'
            }
    } 
        stage ('Configure Test-server with Terraform, Ansible and then Deploying'){
            steps {
                dir('my-serverfiles'){
                sh 'sudo chmod 600 Prabhu.pem'
                sh 'terraform init'
                sh 'terraform validate'
                sh 'terraform apply --auto-approve'
                }
            }
        }
        stage ('Deploy into test-server using Ansible') {
           steps {
             ansiblePlaybook credentialsId: 'Prabhu', disableHostKeyChecking: true, installation: 'ansible', inventory: 'inventory', playbook: 'finance-playbook.yml'
           }
               }
     }
}
