.DEFAULT_GOAL := bootstrap
res ?= vm
command ?= apply
backend ?= remote
env ?= $(TF_ENV)
export SHELL = bash

export TF_INPUT := false
export TF_VAR_token=$(shell yc iam create-token)

bootstrap:
	terragrunt run-all $(command)  --terragrunt-include-dir ./live/$(env)/01-bootstrap/
	@echo 'Your terraform has been prepared. You can now use examples via `make playground res=<your res>`'

reconfigure:
	if [[ $(backend) == 'local' ]]; then export LOCAL_BACKEND=true; fi; \
	terragrunt run-all init -reconfigure -force-copy \
		--terragrunt-include-dir ./live/$(env)/02-examples/$(res) \
		--terragrunt-exclude-dir ./live/$(env)/01-bootstrap/

.run-all:
	if [[ '$(command)' == 'destroy' ]] ; then \
	for a in \
		$(shell terragrunt graph-dependencies --terragrunt-working-dir ./live/$(env)/$(dir) \
			--terragrunt-ignore-external-dependencies | grep "\->" | cut -f 2 -d ">" | sort | uniq | tr -d '";' \
		); \
		do export EXCLUDED_CMD="$${EXCLUDED_CMD} --terragrunt-exclude-dir=$${a}"; \
	done \
	fi && \
	terragrunt run-all $(command) --terragrunt-include-dir ./live/$(env)/$(dir) \
		$${EXCLUDED_CMD}


playground: dir = 02-playground/$(res)
playground: .run-all


clients-repro: dir = '03-clients-repro/$(id)/*/'
clients-repro: .run-all
