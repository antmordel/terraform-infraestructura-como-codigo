# Some of the targets in this file were taken from the terragrunt project:
# https://github.com/gruntwork-io/terragrunt

fmt:
	terraform fmt -recursive

clean:
	find . -type f -name "*.tfstate*" -prune -exec rm -rf {} \;
	find . -type f -name "*.terraform.lock.hcl" -prune -exec rm -rf {} \;
	find . -type d -name "*.terraform" -prune -exec rm -rf {} \;

install-pre-commit-hook:
	@if [ -f .git/hooks/pre-commit -o -L .git/hooks/pre-commit ]; then \
    echo ""; \
    echo "There is already a pre-commit hook installed. Remove it and run 'make"; \
    echo "install-pre-commit-hook again, or manually alter it to add the contents"; \
    echo "of '.scripts/pre-commit'."; \
    echo ""; \
    exit 1; \
  fi
	@ln -s .scripts/pre-commit .git/hooks/pre-commit
	@echo "pre-commit hook installed."
