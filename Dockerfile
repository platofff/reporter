# build
FROM golang:1.14.7-alpine3.12 AS build
WORKDIR /go/src/${owner:-github.com/IzakMarais}/reporter
RUN apk update && apk add make git
ADD . .
RUN make build

# create image
FROM ubuntu:22.04

RUN apt-get update &&\
 apt-get install -y ca-certificates texlive-latex-base texlive-fonts-recommended texlive-lang-cyrillic --no-install-recommends &&\
 rm -rf /var/lib/apt/lists/*

USER nobody

COPY --from=build /go/bin/grafana-reporter /usr/local/bin
ENTRYPOINT [ "/usr/local/bin/grafana-reporter" ]
