TAG ?= latest

.DEFAULT_GOAL: all

all: build push

build:
	docker build ./$(REPO) -t cr.yandex/$(REGISTRY_ID)/$(REPO):$(TAG)

push:
	yc container registry configure-docker
	docker push cr.yandex/$(REGISTRY_ID)/$(REPO):$(TAG)
