FROM golang:1.27-alpine AS builder

ARG TARGETOS
ARG TARGETARCH

ENV CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH}

WORKDIR /app

COPY . .

RUN apk add --no-cache make git

RUN make build

FROM alpine:latest

RUN apk add --no-cache ca-certificates

WORKDIR /

COPY --from=builder /app/kbot .

ENTRYPOINT [ "/kbot" ]
