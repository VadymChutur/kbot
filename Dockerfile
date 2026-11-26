FROM --platform=$BUILDPLATFORM quay.io/projectquay/golang:1.27 AS builder

ARG TARGETOS
ARG TARGETARCH

ENV CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH}

WORKDIR /app

COPY . .

RUN make build

FROM scratch

WORKDIR /

COPY --from=builder /app/kbot .

COPY --from=builder /etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem /etc/ssl/certs/ca-certificates.crt

ENTRYPOINT [ "/kbot" ]
