pipeline {
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    command: ["cat"]
    tty: true
  - name: git
    image: alpine/git:latest
    command: ["cat"]
    tty: true
'''
        }
    }
    stages {
        stage('Build and Push to ECR') {
            steps {
                container('kaniko') {
                    // Оновлено регіон на eu-central-1 та назву репозиторію на lesson-8-9-ecr
                    sh '/kaniko/executor --context=. --dockerfile=Dockerfile --destination=123456789012.dkr.ecr.eu-central-1.amazonaws.com/lesson-8-9-ecr:${BUILD_NUMBER}'
                }
            }
        }
        stage('Update Helm Chart Tag') {
            steps {
                container('git') {
                    sh '''
                        git config --global user.email "jenkins@example.com"
                        git config --global user.name "Jenkins Agent"
                        git clone https://github.com/daria-levchuk/lesson-7-helm-repo.git
                        cd lesson-7-helm-repo
                        sed -i "s/tag:.*/tag: \\"${BUILD_NUMBER}\\"/g" charts/django-app/values.yaml
                        git add charts/django-app/values.yaml
                        git commit -m "Automated image tag update: ${BUILD_NUMBER}"
                        git push origin main
                    '''
                }
            }
        }
    }
}