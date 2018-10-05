FROM golang:latest AS build-env
WORKDIR /go/src/github.com/skysoft-atm/tibco-config-tool
COPY . .
RUN wget -O - https://raw.githubusercontent.com/golang/dep/master/install.sh | sh && \
    dep ensure && \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /go/bin/tibco-config-tool ./main.go

FROM scratch

WORKDIR /app
COPY --from=build-env /go/bin/tibco-config-tool tibco-config-tool
COPY --from=build-env /go/src/github.com/skysoft-atm/tibco-config-tool/configs/application.properties application.properties
EXPOSE 8080

ENTRYPOINT ["/app/tibco-config-tool"]