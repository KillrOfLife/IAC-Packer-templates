init:
	packer init config.pkr.hcl

all: init linux

linux: ubuntu

ubuntu: ubuntu24.04

ubuntu24.04:
	packer build --var-file=credentials.pkr.hcl Ubuntu/Ubuntu24.04/build-base.pkr.hcl

