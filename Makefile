.DEFAULT_GOAL := prepare
res ?= vm
action ?= apply

export TF_INPUT := false

prepare:
	TF_VAR_token=$(shell yc iam create-token) terragrunt run-all apply  --terragrunt-include-dir ./live/test/01-bootstrap/
	@echo 'Your directory has been prepared. You can now use examples via `make example res=<your res>`'

reconfigure:
	if [[ $(backend) == 'local' ]]; then\
		BACKEND_LOCAL=true TF_VAR_token=$(yc iam create-token) terragrunt run-all init -reconfigure -force-copy;\
	else\
		TF_VAR_token=$(yc iam create-token) terragrunt run-all init -reconfigure -force-copy;\
	fi

example:
	terragrunt run-all $(action) --terragrunt-include-dir ./live/test/02-examples/$(res) --terragrunt-exclude-dir ./live/test/01-bootstrap/

clean:
	TF_VAR_token=$(shell yc iam create-token) terragrunt run-all destroy
