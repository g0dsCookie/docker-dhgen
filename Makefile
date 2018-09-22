NAME  ?= g0dscookie/dhgen
MAJOR ?= 1
MINOR ?= 0
PATCH ?= 0

.PHONY: build
build:
	docker build \
		--build-arg "MAJOR=$(MAJOR)" \
		--build-arg "MINOR=$(MINOR)" \
		--build-arg "PATCH=$(PATCH)" \
		-t $(NAME):$(MAJOR) \
		-t $(NAME):$(MAJOR).$(MINOR) \
		-t $(NAME):$(MAJOR).$(MINOR).$(PATCH) \
		-t $(NAME):latest \
		.

.PHONY: push
push:
	docker push $(NAME)

.PHONY: all
all: build push
