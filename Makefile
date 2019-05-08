REPOSITORY?=registry.eventador.io/dev
NAME=sentry-onpremise
TAG?=latest

OK_COLOR=\033[32;01m
NO_COLOR=\033[0m

build:
	@echo "$(OK_COLOR)==>$(NO_COLOR) Building $(REPOSITORY)/$(NAME):$(TAG)"
	@docker build --pull --rm -t $(REPOSITORY)/$(NAME):$(TAG) .

$(REPOSITORY)_$(TAG).tar: build
	@echo "$(OK_COLOR)==>$(NO_COLOR) Saving $(REPOSITORY)/$(NAME):$(TAG) > $@"
	@docker save $(REPOSITORY)/$(NAME):$(TAG) > $@

push: build
	@echo "$(OK_COLOR)==>$(NO_COLOR) Pushing $(REPOSITORY)/$(NAME):$(TAG)"
	@docker push $(REPOSITORY)/$(NAME):$(TAG)

all: build push

.PHONY: all build push
