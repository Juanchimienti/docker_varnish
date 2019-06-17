FROM alpine:3.8

ENV VARNISH_VERSION=6.0.0

RUN apk update; apk add varnish varnish~${VARNISH_VERSION} curl

USER varnish

ADD start.sh /

CMD ["/start.sh"]

