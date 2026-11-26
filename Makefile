APP:=$(shell basename $$(git remote get-url origin) .git)
REGISTRY:=falloutgreck
VERSION:=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS:=linux
TARGETARCH:=amd64

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
	docker build -t ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH} -f Dockerfile .

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}
	
clean:
	rm -fr kbot