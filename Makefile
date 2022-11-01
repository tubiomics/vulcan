#!make
PROFILE=default
include .env
# Self-Documented Makefile see https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.DEFAULT_GOAL := help

.PHONY: help
# Put it first so that "make" without argument is like "make help".
help:
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-32s-\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: clean
clean:  ## Cleanup project directory
	@rm -rf work/; \
	rm -rf .nextflow* ; \
	rm -rf results\

.PHONY: download-data
download-data:  ## Download dev/test data from S3 Bucket to Data dir
	@echo 'Downloading reads to  ./data/raw/reads'; \
	aws s3 cp ${S3_BASE}/raw/TESTING_fe4b1358_20210909/e6a90ac0f4eb/  ./data/raw/reads/ --recursive --profile ${PROFILE}; \

.PHONY: build-image
build-image:  ## Build Docker image.
	@docker build -t tubiomics/vulcan:latest .

.PHONY: pull-image
pull-image:  ## Pull docker image from Docker Hub Registry.
	@docker pull tubiomics/vulcan:latest
