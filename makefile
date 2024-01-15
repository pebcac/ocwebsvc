# Makefile for OpenShift/Kubernetes Deployment

# Define variables
NAMESPACE := test
IMAGE_NAME := your-image-name
IMAGE_TAG := latest
DOCKER_REGISTRY := your-docker-registry

# Default target
all: deploy

# Deploy everything
deploy: deploy-sa deploy-role deploy-rolebinding deploy-app

# Deploy Service Account
deploy-sa:
	kubectl apply -f serviceaccount.yaml

# Deploy Role
deploy-role:
	kubectl apply -f role.yaml

# Deploy RoleBinding
deploy-rolebinding:
	kubectl apply -f rolebinding.yaml

# Deploy Application
deploy-app:
	kubectl apply -f deployment.yaml
	kubectl apply -f service.yaml

# Build and push Docker image
build-push-image:
	docker build -t $(DOCKER_REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG) .
	docker push $(DOCKER_REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG)

# Run Tests
test:
	kubectl -n $(NAMESPACE) get all
	@echo "Running additional tests..."
	# Here you can add your specific tests (e.g., curl for checking a web service)

# Clean up resources
clean:
	kubectl delete -f deployment.yaml
	kubectl delete -f service.yaml
	kubectl delete -f rolebinding.yaml
	kubectl delete -f role.yaml
	kubectl delete -f serviceaccount.yaml

# Help
help:
	@echo "Makefile for deploying and managing OpenShift/Kubernetes resources"
	@echo ""
	@echo "Usage:"
	@echo "  make deploy             - Deploy all resources to the cluster"
	@echo "  make build-push-image   - Build and push Docker image"
	@echo "  make test               - Run tests"
	@echo "  make clean              - Delete all deployed resources"
	@echo "  make help               - Show this help message"

.PHONY: deploy deploy-sa deploy-role deploy-rolebinding deploy-app build-push-image test clean help
