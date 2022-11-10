FROM golang:1.19.3-alpine3.16 AS build

LABEL maintainer="mail@xiaoliu.org"

WORKDIR /go/src/app

ADD . .

ENV CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=arm64

RUN go build -ldflags="-w -s" -o zhimiao-app

FROM alpine:3.16.2@sha256:ed73e2bee79b3428995b16fce4221fc715a849152f364929cdccdc83db5f3d5c AS prod

WORKDIR /zhimiao

COPY --from=build /go/src/app/zhimiao-app .

RUN chmod +x zhimiao-app

EXPOSE 1325

ENTRYPOINT ["/zhimiao/zhimiao-app"]
