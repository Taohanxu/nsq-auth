FROM golang:1.19.3-alpine3.16@sha256:c1b7c8fb2603c387a668768f4a7fda4c2adb077c00a97b596ff6569f7a4c20ae AS build

LABEL maintainer="mail@xiaoliu.org"

WORKDIR /go/src/app

ADD . .

ENV GOPROXY="https://goproxy.cn,direct" \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

RUN go build -ldflags="-w -s" -o zhimiao-app

FROM zhimiao/alpine:latest AS prod

WORKDIR /zhimiao

COPY --from=build /go/src/app/zhimiao-app .

RUN chmod +x zhimiao-app

EXPOSE 1325

ENTRYPOINT ["/zhimiao/zhimiao-app"]
