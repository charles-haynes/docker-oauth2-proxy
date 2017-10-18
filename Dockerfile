FROM alpine:latest as build

ENV OAUTH2_PROXY_VERSION="2.2"
ENV OAUTH2_PROXY_PKG="oauth2_proxy-${OAUTH2_PROXY_VERSION}.0.linux-amd64.go1.8.1"
ENV OAUTH2_PROXY_SHA="1c16698ed0c85aa47aeb80e608f723835d9d1a8b98bd9ae36a514826b3acce56"
ENV BUILD_PKGS="wget ca-certificates"

WORKDIR /tmp
RUN apk update && \
    apk upgrade && \
    apk add $BUILD_PKGS && \
    wget --progress=dot:mega \
         https://github.com/bitly/oauth2_proxy/releases/download/v${OAUTH2_PROXY_VERSION}/${OAUTH2_PROXY_PKG}.tar.gz && \
    echo "${OAUTH2_PROXY_SHA} *${OAUTH2_PROXY_PKG}.tar.gz" | sha256sum -c - && \
    tar xvf ${OAUTH2_PROXY_PKG}.tar.gz && \
    cp /tmp/${OAUTH2_PROXY_PKG}/oauth2_proxy /bin/

#####
FROM alpine:latest

ENV APP_PKGS="ca-certificates"

RUN apk update && \
    apk upgrade && \
    apk add $APP_PKGS

COPY --from=build /bin/oauth2_proxy /bin/

EXPOSE 4180

ENTRYPOINT ["/bin/oauth2_proxy"]
