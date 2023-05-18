.DEFAULT_GOAL := help

help: ## Display this help text
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: clean
clean:  ## Clean all working/temporary files
	rm -rf `find . -name __pycache__`
	rm -f `find . -type f -name '*.py[co]' `
	rm -f `find . -type f -name '*~' `
	rm -f `find . -type f -name '.*~' `
	rm -rf .cache
	rm -rf .pytest_cache
	rm -rf .mypy_cache
	rm -rf htmlcov
	rm -rf *.egg-info
	rm -f .coverage
	rm -f .coverage.*
	rm -rf build
	# python setup.py clean

.PHONY: up build schema index

# DOCKER STUFF
up: ## Start server using Docker
	docker-compose up

up-d: ## Start server using Docker in background
	docker-compose up -d
	
setup: build up-d schema index ## Run a full local setup
	
down: ## Stop server using docker
	docker-compose down

build: ## Build the dev Docker image
	docker-compose build

docker-clean: ## Get rid of the local docker env and DB
	docker-compose down

schema: ## Initialise Explorer DB using Docker
	docker-compose exec -T explorer \
		cubedash-gen -v --init

index: ## Update Explorer DB using Docker
	docker-compose exec -T explorer \
		cubedash-gen --all
