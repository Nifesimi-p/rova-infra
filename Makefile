.PHONY: help bootstrap-init bootstrap-plan bootstrap-apply init plan fmt validate helm-lint helm-dry-run docker-build clean

ENV ?= dev
AWS_REGION ?= eu-west-1

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

bootstrap-init: ## Initialise the bootstrap module (one-time setup)
	cd bootstrap && terraform init

bootstrap-plan: ## Plan bootstrap changes
	cd bootstrap && terraform plan

bootstrap-apply: ## Apply bootstrap. Run once with admin credentials before anything else.
	cd bootstrap && terraform apply

init: ## Initialise root terraform with the S3 backend
	terraform init \
		-backend-config="bucket=$(TFSTATE_BUCKET)" \
		-backend-config="region=$(AWS_REGION)" \
		-backend-config="dynamodb_table=$(TFSTATE_LOCK_TABLE)"

plan: ## Terraform plan (override environment with ENV=prod)
	terraform plan -var-file=environments/$(ENV).tfvars -out=tfplan

fmt: ## Format all terraform files
	terraform fmt -recursive

validate: ## Validate terraform configuration
	terraform init -backend=false && terraform validate

lint: fmt validate ## Run all terraform quality checks locally

helm-lint: ## Lint the helm chart
	helm lint ./helm/microservice --strict

helm-dry-run: ## Render the chart against dev values
	helm template rova-dev ./helm/microservice \
		--debug \
		--namespace dev \
		--set ingress.host=api.dev.rova.com

helm-dry-run-prod: ## Render the chart against production values
	helm template rova-prod ./helm/microservice \
		--debug \
		--namespace production \
		-f ./helm/microservice/values-prod.yaml

docker-build: ## Build the microservice image locally
	docker build -t rova-microservice:local .

clean: ## Remove local terraform artifacts
	rm -f tfplan
	find . -type d -name ".terraform" -exec rm -rf {} +