#!/bin/bash

# QazaqAir Infrastructure Deployment Script
# Module 9: IaC - Infrastructure as Code
# Usage: ./deploy.sh [environment] [action]
# Environments: dev, staging, production
# Actions: setup, security, monitoring, terraform, all

set -e

# ============================================================================
# CONFIGURATION
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_NAME="qazaqair"
TERRAFORM_DIR="${SCRIPT_DIR}/terraform"
ANSIBLE_DIR="${SCRIPT_DIR}/ansible"
LOG_FILE="${SCRIPT_DIR}/deploy.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
ENVIRONMENT="${1:-production}"
ACTION="${2:-all}"

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "${LOG_FILE}"
}

print_header() {
    echo -e "${BLUE}"
    echo "============================================================================="
    echo "  QAZAQAIR INFRASTRUCTURE DEPLOYMENT"
    echo "============================================================================="
    echo -e "${NC}"
    echo -e "Environment: ${YELLOW}${ENVIRONMENT}${NC}"
    echo -e "Action: ${YELLOW}${ACTION}${NC}"
    echo ""
}

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1" | tee -a "${LOG_FILE}"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "${LOG_FILE}"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "${LOG_FILE}"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "${LOG_FILE}"
}

# ============================================================================
# VALIDATION FUNCTIONS
# ============================================================================

check_prerequisites() {
    print_status "Checking prerequisites..."
    
    local missing=()
    
    # Check Docker
    if ! command -v docker &> /dev/null; then
        missing+=("docker")
    else
        print_status "Docker: $(docker --version)"
    fi
    
    # Check Docker Compose
    if ! command -v docker-compose &> /dev/null; then
        missing+=("docker-compose")
    else
        print_status "Docker Compose: $(docker-compose --version)"
    fi
    
    # Check Terraform
    if ! command -v terraform &> /dev/null; then
        missing+=("terraform")
    else
        print_status "Terraform: $(terraform version | head -1)"
    fi
    
    # Check Ansible
    if ! command -v ansible &> /dev/null; then
        missing+=("ansible")
    else
        print_status "Ansible: $(ansible --version | head -1)"
    fi
    
    if [ ${#missing[@]} -ne 0 ]; then
        print_error "Missing prerequisites: ${missing[*]}"
        print_error "Please install missing tools before proceeding."
        exit 1
    fi
    
    print_success "All prerequisites satisfied!"
}

# ============================================================================
# ANSIBLE FUNCTIONS
# ============================================================================

run_ansible_setup() {
    print_status "Running Ansible setup playbook..."
    
    cd "${ANSIBLE_DIR}"
    
    ansible-playbook \
        -i inventory.ini \
        setup.yml \
        --extra-vars "environment=${ENVIRONMENT}"
    
    print_success "Setup complete!"
}

run_ansible_security() {
    print_status "Running Ansible security hardening..."
    
    cd "${ANSIBLE_DIR}"
    
    ansible-playbook \
        -i inventory.ini \
        security.yml \
        --extra-vars "environment=${ENVIRONMENT}"
    
    print_success "Security hardening complete!"
}

run_ansible_monitoring() {
    print_status "Running Ansible monitoring setup..."
    
    cd "${ANSIBLE_DIR}"
    
    ansible-playbook \
        -i inventory.ini \
        monitoring.yml \
        --extra-vars "environment=${ENVIRONMENT}"
    
    print_success "Monitoring setup complete!"
}

# ============================================================================
# TERRAFORM FUNCTIONS
# ============================================================================

run_terraform_init() {
    print_status "Initializing Terraform..."
    
    cd "${TERRAFORM_DIR}"
    
    terraform init
    
    print_success "Terraform initialized!"
}

run_terraform_plan() {
    print_status "Planning Terraform changes..."
    
    cd "${TERRAFORM_DIR}"
    
    terraform plan \
        -var="environment=${ENVIRONMENT}" \
        -out=tfplan
    
    print_success "Terraform plan created!"
}

run_terraform_apply() {
    print_status "Applying Terraform configuration..."
    
    cd "${TERRAFORM_DIR}"
    
    terraform apply \
        -auto-approve \
        tfplan
    
    print_success "Terraform apply complete!"
}

run_terraform_destroy() {
    print_warning "This will DESTROY all infrastructure!"
    read -p "Are you sure? (yes/no): " confirm
    
    if [ "$confirm" = "yes" ]; then
        cd "${TERRAFORM_DIR}"
        
        terraform destroy \
            -var="environment=${ENVIRONMENT}" \
            -auto-approve
        
        print_success "Infrastructure destroyed!"
    else
        print_status "Destroy cancelled."
    fi
}

run_terraform_output() {
    print_status "Getting Terraform outputs..."
    
    cd "${TERRAFORM_DIR}"
    
    terraform output
}

# ============================================================================
# DOCKER FUNCTIONS
# ============================================================================

run_docker_build() {
    print_status "Building Docker images..."
    
    cd "${SCRIPT_DIR}"
    
    # Build backend
    docker build -t "${PROJECT_NAME}-backend:latest" .
    
    # Build frontend
    docker build -t "${PROJECT_NAME}-frontend:latest" ./frontend_new
    
    print_success "Docker images built!"
}

run_docker_deploy() {
    print_status "Deploying with Docker Compose..."
    
    cd "${SCRIPT_DIR}"
    
    docker-compose up -d --build
    
    print_success "Docker deployment complete!"
}

run_docker_stop() {
    print_status "Stopping Docker containers..."
    
    cd "${SCRIPT_DIR}"
    
    docker-compose down
    
    print_success "Docker containers stopped!"
}

# ============================================================================
# BACKUP FUNCTIONS
# ============================================================================

run_backup() {
    print_status "Creating backup..."
    
    BACKUP_DIR="${SCRIPT_DIR}/backups"
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    BACKUP_FILE="${BACKUP_DIR}/backup_${TIMESTAMP}.sql"
    
    mkdir -p "${BACKUP_DIR}"
    
    # Backup PostgreSQL
    docker exec qazaqair-db-1 pg_dump -U user airmonitor > "${BACKUP_FILE}"
    
    # Backup volumes
    tar -czf "${BACKUP_DIR}/volumes_${TIMESTAMP}.tar.gz" \
        /var/lib/docker/volumes/qazaqair-*
    
    print_success "Backup created: ${BACKUP_FILE}"
}

# ============================================================================
# STATUS AND LOGS
# ============================================================================

show_status() {
    print_status "Infrastructure Status"
    
    echo ""
    echo -e "${BLUE}Docker Containers:${NC}"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -E "(NAMES|qazaqair)" || echo "No containers running"
    
    echo ""
    echo -e "${BLUE}Docker Volumes:${NC}"
    docker volume ls | grep qazaqair || echo "No volumes found"
    
    echo ""
    echo -e "${BLUE}Docker Networks:${NC}"
    docker network ls | grep qazaqair || echo "No networks found"
}

show_logs() {
    local service="${1:-}"
    
    cd "${SCRIPT_DIR}"
    
    if [ -n "$service" ]; then
        docker-compose logs -f "$service"
    else
        docker-compose logs -f
    fi
}

# ============================================================================
# FULL DEPLOYMENT
# ============================================================================

run_full_deployment() {
    print_header
    
    print_status "Starting full deployment of QazaqAir infrastructure..."
    
    # Step 1: Prerequisites
    check_prerequisites
    
    # Step 2: Initial setup
    run_ansible_setup
    
    # Step 3: Security hardening
    run_ansible_security
    
    # Step 4: Monitoring setup
    run_ansible_monitoring
    
    # Step 5: Terraform init
    run_terraform_init
    
    # Step 6: Terraform plan
    run_terraform_plan
    
    # Step 7: Terraform apply
    run_terraform_apply
    
    # Step 8: Build and deploy Docker
    run_docker_build
    run_docker_deploy
    
    # Step 9: Show status
    show_status
    
    # Step 10: Show Terraform outputs
    run_terraform_output
    
    print_success "Full deployment complete!"
}

# ============================================================================
# MAIN
# ============================================================================

case "${ACTION}" in
    setup)
        run_ansible_setup
        ;;
    security)
        run_ansible_security
        ;;
    monitoring)
        run_ansible_monitoring
        ;;
    terraform-init)
        run_terraform_init
        ;;
    terraform-plan)
        run_terraform_plan
        ;;
    terraform-apply)
        run_terraform_apply
        ;;
    terraform-destroy)
        run_terraform_destroy
        ;;
    terraform-output)
        run_terraform_output
        ;;
    docker-build)
        run_docker_build
        ;;
    docker-deploy)
        run_docker_deploy
        ;;
    docker-stop)
        run_docker_stop
        ;;
    backup)
        run_backup
        ;;
    status)
        show_status
        ;;
    logs)
        shift 2
        show_logs "$@"
        ;;
    all)
        run_full_deployment
        ;;
    *)
        echo "Usage: $0 [environment] [action]"
        echo ""
        echo "Environments: dev, staging, production"
        echo ""
        echo "Actions:"
        echo "  setup           - Run initial server setup (Ansible)"
        echo "  security        - Apply security hardening (Ansible)"
        echo "  monitoring      - Setup monitoring stack (Ansible)"
        echo "  terraform-init  - Initialize Terraform"
        echo "  terraform-plan  - Plan Terraform changes"
        echo "  terraform-apply - Apply Terraform configuration"
        echo "  terraform-destroy - Destroy infrastructure (DANGER!)"
        echo "  terraform-output - Show Terraform outputs"
        echo "  docker-build    - Build Docker images"
        echo "  docker-deploy   - Deploy with Docker Compose"
        echo "  docker-stop     - Stop Docker containers"
        echo "  backup          - Create backup"
        echo "  status          - Show infrastructure status"
        echo "  logs [service]  - Show logs (optionally filtered by service)"
        echo "  all             - Run complete deployment (default)"
        echo ""
        echo "Examples:"
        echo "  $0 production all              # Full deployment"
        echo "  $0 production setup            # Just server setup"
        echo "  $0 production security         # Just security hardening"
        echo "  $0 production terraform-apply  # Just Terraform apply"
        echo "  $0 production status           # Check status"
        exit 1
        ;;
esac

exit 0
