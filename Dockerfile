# build
FROM golang:1.21-bookworm AS build
WORKDIR /go/src/${owner:-github.com/platofff}/reporter
RUN apt-get update &&\
 apt-get install -y make git --no-install-recommends &&\
 rm -rf /var/lib/apt/lists/*
ADD . .
RUN make build

# create image
FROM debian:bookworm

RUN apt-get update &&\
 apt-get install -y texlive-latex-base texlive-fonts-recommended texlive-lang-cyrillic --no-install-recommends &&\
 rm -rf /var/lib/apt/lists/*
COPY --from=build /go/bin/grafana-reporter /usr/local/bin/grafana-reporter
RUN chmod +x /usr/local/bin/grafana-reporter
USER nobody

ENTRYPOINT [ "/usr/local/bin/grafana-reporter" ]
