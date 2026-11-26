APP:=$(shell basename $$(git remote get-url origin) .git)
REGISTRY:=ghcr.io/vadymchutur
VERSION:=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS ?= $(shell go env GOOS)
TARGETARCH ?= $(shell go env GOARCH)

linux:
	$(MAKE) build TARGETOS=linux TARGETARCH=amd64

arm:
	$(MAKE) build TARGETOS=linux TARGETARCH=arm

macos:
	$(MAKE) build TARGETOS=darwin TARGETARCH=arm64

windows:
	$(MAKE) build TARGETOS=windows TARGETARCH=amd64

format:
	gofmt -s -w ./

lint:
	golangci-lint run

test:
	go test -v

get:
	go get

build: format
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X=github.com/VadymChutur/kbot.git/cmd.appVersion=${VERSION}" 

image:
	docker build -t ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH} --build-arg TARGETOS=${TARGETOS} --build-arg TARGETARCH=${TARGETARCH} -f Dockerfile .

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}
	
clean:
	rm -fr kbot
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH} || true
	docker rmi ${REGISTRY}/${APP}:${VERSION} || true
	docker rmi ${REGISTRY}/${APP} || true