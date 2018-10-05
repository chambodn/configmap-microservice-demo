FROM golang:latest AS build-env
WORKDIR /go/src/github.com/chambodn/configmap-microservice-demo
COPY . .
RUN wget -O - https://raw.githubusercontent.com/golang/dep/master/install.sh | sh && \
    dep ensure && \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /go/bin/configmap-microservice-demo .

FROM scratch

WORKDIR /app
COPY --from=build-env /go/bin/configmap-microservice-demo configmap-microservice-demo
COPY --from=build-env /go/src/github.com/chambodn/configmap-microservice-demo/config.yaml config.yaml
EXPOSE 8080

ENTRYPOINT ["/app/configmap-microservice-demo"]