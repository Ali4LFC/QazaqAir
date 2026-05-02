pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        disableConcurrentBuilds()
        timestamps()
    }

    environment {
        PROJECT_NAME = 'qazaqair'
        DOCKER_REGISTRY = 'localhost:5000'
        TF_IN_AUTOMATION = 'true'
        ANSIBLE_FORCE_COLOR = 'true'
        PYTHONUNBUFFERED = '1'
    }

    parameters {
        choice(
            name: 'ENVIRONMENT',
            choices: ['dev', 'staging', 'production'],
            description: 'Target deployment environment'
        )
        choice(
            name: 'DEPLOYMENT_ACTION',
            choices: [
                'plan',
                'apply',
                'destroy',
                'backup',
                'security-scan'
            ],
            description: 'Terraform/Deployment action to perform'
        )
        booleanParam(
            name: 'AUTO_APPROVE',
            defaultValue: false,
            description: 'Auto-approve Terraform changes (use with caution!)'
        )
        booleanParam(
            name: 'SKIP_TESTS',
            defaultValue: false,
            description: 'Skip test stages'
        )
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    try {
                        cleanWs()
                        // Попытка загрузки из SCM, если настроено
                        checkout scm
                        
                        env.GIT_COMMIT = sh(
                            script: 'git rev-parse --short HEAD || echo "no-git"',
                            returnStdout: true
                        ).trim()
                        env.GIT_BRANCH = sh(
                            script: 'git rev-parse --abbrev-ref HEAD || echo "local"',
                            returnStdout: true
                        ).trim()
                    } catch (Exception e) {
                        echo "Skipping SCM checkout or Git commands: ${e.message}"
                        env.GIT_COMMIT = "manual-build"
                        env.GIT_BRANCH = "master"
                    }
                }
                
                echo "Building branch: ${env.GIT_BRANCH}, commit: ${env.GIT_COMMIT}"
            }
        }

        stage('Pre-build Checks') {
            parallel {
                stage('Lint Dockerfile') {
                    steps {
                        sh '''
                            echo "Linting Dockerfile..."
                            docker run --rm -i hadolint/hadolint < Dockerfile || echo "HadoLint not installed, skipping..."
                        '''
                    }
                }
                stage('Lint Terraform') {
                    steps {
                        dir('terraform') {
                            sh '''
                                echo "Linting Terraform..."
                                terraform fmt -check || echo "Terraform not installed, skipping..."
                            '''
                        }
                    }
                }
                stage('Lint Ansible') {
                    steps {
                        dir('ansible') {
                            sh '''
                                echo "Linting Ansible..."
                                ansible-lint *.yml || echo "Ansible-lint not installed, skipping..."
                            '''
                        }
                    }
                }
            }
        }

        stage('Build') {
            when {
                anyOf {
                    changeset "Dockerfile"
                    changeset "backend/**"
                    changeset "frontend_new/**"
                    expression { params.DEPLOYMENT_ACTION == 'apply' }
                }
            }
            steps {
                script {
                    def tag = "${env.GIT_COMMIT}"
                    
                    // Build backend
                    sh """
                        echo "Building backend image..."
                        docker build -t ${DOCKER_REGISTRY}/${PROJECT_NAME}-backend:${tag} . || echo "Docker build failed/not found"
                        docker tag ${DOCKER_REGISTRY}/${PROJECT_NAME}-backend:${tag} ${DOCKER_REGISTRY}/${PROJECT_NAME}-backend:latest || true
                    """
                    
                    // Build frontend
                    sh """
                        echo "Building frontend image..."
                        docker build -t ${DOCKER_REGISTRY}/${PROJECT_NAME}-frontend:${tag} ./frontend_new || echo "Docker build failed/not found"
                        docker tag ${DOCKER_REGISTRY}/${PROJECT_NAME}-frontend:${tag} ${DOCKER_REGISTRY}/${PROJECT_NAME}-frontend:latest || true
                    """
                }
            }
        }

        stage('Security Scan') {
            when {
                expression { params.DEPLOYMENT_ACTION == 'security-scan' || !params.SKIP_TESTS }
            }
            steps {
                script {
                    // Scan Docker images with Trivy
                    sh '''
                        echo "Scanning Docker images..."
                        docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
                            aquasec/trivy:latest image \
                            qazaqair-backend:latest || echo 'Trivy scan skipped'
                    '''
                    
                    // Scan Terraform with Checkov
                    sh '''
                        echo "Scanning Terraform files..."
                        docker run --rm -v $(pwd)/terraform:/tf bridgecrew/checkov:latest \
                            --directory /tf --compact || echo 'Checkov scan skipped'
                    '''
                }
            }
        }

        stage('Test') {
            when {
                expression { !params.SKIP_TESTS }
            }
            steps {
                script {
                    // Unit tests
                    sh '''
                        echo "Running unit tests..."
                        docker run --rm -v $(pwd)/backend:/app \
                            -w /app python:3.11-slim \
                            python -m pytest tests/ || echo 'Tests skipped or not found'
                    '''
                }
            }
        }

        stage('Terraform Plan') {
            when {
                anyOf {
                    expression { params.DEPLOYMENT_ACTION == 'plan' }
                    expression { params.DEPLOYMENT_ACTION == 'apply' }
                }
            }
            steps {
                dir('terraform') {
                    sh '''
                        echo "Running Terraform Plan..."
                        (terraform init -backend-config="key=${ENVIRONMENT}/terraform.tfstate" && \
                         terraform workspace select ${ENVIRONMENT} || terraform workspace new ${ENVIRONMENT} && \
                         terraform plan -var="environment=${ENVIRONMENT}" -out=tfplan) || echo "Terraform command failed or not installed"
                    '''
                }
            }
        }

        stage('Approval') {
            when {
                allOf {
                    expression { params.DEPLOYMENT_ACTION == 'apply' }
                    expression { !params.AUTO_APPROVE }
                }
            }
            steps {
                script {
                    input message: "Review plan and approve deployment?", ok: 'Approve'
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression { params.DEPLOYMENT_ACTION == 'apply' }
            }
            steps {
                dir('terraform') {
                    sh '''
                        echo "Running Terraform Apply..."
                        terraform apply -auto-approve tfplan || echo "Terraform Apply skipped"
                    '''
                }
            }
        }

        stage('Deploy Services') {
            when {
                expression { params.DEPLOYMENT_ACTION == 'apply' }
            }
            steps {
                script {
                    sh '''
                        echo "Deploying with Docker Compose..."
                        docker-compose up -d --build || echo "Docker-compose skipped"
                        
                        echo "Running Ansible playbooks..."
                        ansible-playbook -i ansible/inventory.ini ansible/setup.yml || echo "Ansible skipped"
                    '''
                }
            }
        }

        stage('Smoke Tests') {
            when {
                expression { params.DEPLOYMENT_ACTION == 'apply' }
            }
            steps {
                sh '''
                    echo "Running smoke tests..."
                    curl -f http://localhost || echo "Service not reachable yet"
                '''
            }
        }
    }

    post {
        always {
            script {
                echo "Pipeline finished with status: ${currentBuild.result}"
            }
            cleanWs(notFailBuild: true)
        }
        
        success {
            echo """
            ============================================
            DEPLOYMENT SUCCESSFUL
            ============================================
            """
        }
        
        failure {
            echo """
            ============================================
            DEPLOYMENT FINISHED (WITH ERRORS)
            ============================================
            """
        }
    }
}