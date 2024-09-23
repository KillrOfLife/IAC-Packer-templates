default: help

.PHONY: init
init: ## Initializes packer
	packer init config.pkr.hcl

.PHONY: all
all: init ubuntu24-04 ## Creates all templates

.PHONY: ubuntu24-04
ubuntu24-04: ## Creates the specific template for this OS and version
	@packer build --var-file=credentials.pkr.hcl Linux/Ubuntu24-04/build.pkr.hcl


.PHONY: help
help: ## Display this information. Default target.
	@echo "Valid targets:"
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'
