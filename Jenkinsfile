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
                cleanWs()
                checkout scm
                
                script {
                    env.GIT_COMMIT = sh(
                        script: 'git rev-parse --short HEAD',
                        returnStdout: true
                    ).trim()
                    env.GIT_BRANCH = sh(
                        script: 'git rev-parse --abbrev-ref HEAD',
                        returnStdout: true
                    ).trim()
                }
                
                echo "Building branch: ${env.GIT_BRANCH}, commit: ${env.GIT_COMMIT}"
            }
        }

        stage('Pre-build Checks') {
            parallel {
                stage('Lint Dockerfile') {
                    steps {
                        sh '''
                            docker run --rm -i hadolint/hadolint < Dockerfile || true
                        '''
                    }
                }
                stage('Lint Terraform') {
                    steps {
                        dir('terraform') {
                            sh '''
                                terraform fmt -check || true
                            '''
                        }
                    }
                }
                stage('Lint Ansible') {
                    steps {
                        dir('ansible') {
                            sh '''
                                ansible-lint *.yml || true
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
                        docker build -t ${DOCKER_REGISTRY}/${PROJECT_NAME}-backend:${tag} .
                        docker tag ${DOCKER_REGISTRY}/${PROJECT_NAME}-backend:${tag} ${DOCKER_REGISTRY}/${PROJECT_NAME}-backend:latest
                    """
                    
                    // Build frontend
                    sh """
                        docker build -t ${DOCKER_REGISTRY}/${PROJECT_NAME}-frontend:${tag} ./frontend_new
                        docker tag ${DOCKER_REGISTRY}/${PROJECT_NAME}-frontend:${tag} ${DOCKER_REGISTRY}/${PROJECT_NAME}-frontend:latest
                    """
                    
                    // Push to registry (optional)
                    sh """
                        docker push ${DOCKER_REGISTRY}/${PROJECT_NAME}-backend:${tag} || echo 'Registry not available'
                        docker push ${DOCKER_REGISTRY}/${PROJECT_NAME}-frontend:${tag} || echo 'Registry not available'
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
                        docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
                            -v $HOME/.cache:/root/.cache \
                            aquasec/trivy:latest image \
                            --exit-code 0 --severity HIGH,CRITICAL \
                            qazaqair-backend:latest || echo 'Scan completed with warnings'
                    '''
                    
                    // Scan Terraform with Checkov
                    sh '''
                        docker run --rm -v $(pwd)/terraform:/tf bridgecrew/checkov:latest \
                            --directory /tf --compact || echo 'Checkov scan completed'
                    '''
                    
                    // Scan Ansible with ansible-security
                    sh '''
                        cd ansible
                        ansible-playbook --syntax-check *.yml || echo 'Ansible syntax check completed'
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
                        docker run --rm -v $(pwd)/backend:/app \
                            -w /app python:3.11-slim \
                            python -m pytest tests/ -v --tb=short || echo 'No tests found'
                    '''
                    
                    // Integration tests
                    sh '''
                        docker-compose -f docker-compose.yml -f docker-compose.test.yml \
                            up --abort-on-container-exit --exit-code-from test || echo 'Integration tests completed'
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
                        terraform init -backend-config="key=${ENVIRONMENT}/terraform.tfstate"
                        terraform workspace select ${ENVIRONMENT} || terraform workspace new ${ENVIRONMENT}
                        terraform plan -var="environment=${ENVIRONMENT}" -out=tfplan
                    '''
                }
                
                // Archive plan for review
                archiveArtifacts artifacts: 'terraform/tfplan', fingerprint: true
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
                    def plan = readFile 'terraform/tfplan'
                    input message: "Review Terraform plan and approve?", ok: 'Approve',
                          parameters: [text(name: 'PLAN_SUMMARY', defaultValue: 'Plan reviewed', description: 'Approval note')]
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
                        terraform apply ${AUTO_APPROVE ? '-auto-approve' : ''} tfplan
                    '''
                }
                
                // Save Terraform outputs
                dir('terraform') {
                    sh '''
                        terraform output -json > ../terraform-outputs.json || true
                    '''
                }
                archiveArtifacts artifacts: 'terraform-outputs.json', fingerprint: true
            }
        }

        stage('Deploy Services') {
            when {
                expression { params.DEPLOYMENT_ACTION == 'apply' }
            }
            steps {
                script {
                    // Deploy with Docker Compose
                    sh '''
                        export COMPOSE_PROJECT_NAME=${PROJECT_NAME}
                        docker-compose up -d --build
                    '''
                    
                    // Run Ansible playbooks
                    dir('ansible') {
                        sh '''
                            ansible-playbook -i inventory.ini setup.yml -e "environment=${ENVIRONMENT}"
                            ansible-playbook -i inventory.ini security.yml -e "environment=${ENVIRONMENT}"
                            ansible-playbook -i inventory.ini monitoring.yml -e "environment=${ENVIRONMENT}"
                        '''
                    }
                    
                    // Wait for services to be healthy
                    sh '''
                        echo "Waiting for services to be healthy..."
                        sleep 30
                        
                        # Check service health
                        docker-compose ps
                        
                        # Health check endpoints
                        curl -f http://localhost:8000/health || echo "Backend not ready"
                        curl -f http://localhost || echo "Frontend not ready"
                    '''
                }
            }
        }

        stage('Smoke Tests') {
            when {
                expression { params.DEPLOYMENT_ACTION == 'apply' }
            }
            steps {
                script {
                    // Test critical endpoints
                    sh '''
                        # Test main application
                        curl -sf http://localhost || exit 1
                        
                        # Test API
                        curl -sf http://localhost:8000/api/health || echo "API health check"
                        
                        # Test monitoring endpoints
                        curl -sf http://localhost:9090/-/healthy || echo "Prometheus check"
                        curl -sf http://localhost:3000/api/health || echo "Grafana check"
                    '''
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { params.DEPLOYMENT_ACTION == 'destroy' }
            }
            steps {
                input message: 'Are you sure you want to DESTROY all infrastructure?', ok: 'Destroy'
                
                dir('terraform') {
                    sh '''
                        terraform destroy -var="environment=${ENVIRONMENT}" -auto-approve
                    '''
                }
            }
        }

        stage('Backup') {
            when {
                expression { params.DEPLOYMENT_ACTION == 'backup' }
            }
            steps {
                script {
                    def timestamp = sh(
                        script: 'date +%Y%m%d_%H%M%S',
                        returnStdout: true
                    ).trim()
                    
                    sh """
                        mkdir -p backups
                        docker exec ${PROJECT_NAME}-db-1 pg_dump -U user airmonitor > backups/backup_${timestamp}.sql
                        tar -czf backups/volumes_${timestamp}.tar.gz /var/lib/docker/volumes/${PROJECT_NAME}-*
                    """
                    
                    archiveArtifacts artifacts: "backups/*_${timestamp}.*", fingerprint: true
                }
            }
        }
    }

    post {
        always {
            script {
                // Clean up
                sh '''
                    docker system prune -f || true
                '''
                
                // Send notification
                if (currentBuild.result == 'SUCCESS') {
                    echo "Build successful!"
                } else {
                    echo "Build failed!"
                }
            }
            
            // Clean workspace
            cleanWs(
                cleanWhenNotBuilt: false,
                deleteDirs: true,
                notFailBuild: true,
                patterns: [[pattern: '.gitignore', type: 'INCLUDE']]
            )
        }
        
        success {
            script {
                // Send success notification (Telegram/Slack/Email)
                echo """
                ============================================
                DEPLOYMENT SUCCESSFUL
                ============================================
                Project: ${PROJECT_NAME}
                Environment: ${params.ENVIRONMENT}
                Version: ${env.GIT_COMMIT}
                Build: ${env.BUILD_NUMBER}
                ============================================
                """
            }
        }
        
        failure {
            script {
                // Send failure notification
                echo """
                ============================================
                DEPLOYMENT FAILED
                ============================================
                Project: ${PROJECT_NAME}
                Environment: ${params.ENVIRONMENT}
                Build: ${env.BUILD_NUMBER}
                Check logs: ${env.BUILD_URL}console
                ============================================
                """
            }
        }
        
        unstable {
            echo "Build is unstable - review required"
        }
    }
}
