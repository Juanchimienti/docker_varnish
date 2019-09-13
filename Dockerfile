FROM alpine:3.10

ENV VARNISH_VERSION=6.2

RUN apk update; apk add varnish varnish~${VARNISH_VERSION} curl

USER varnish

ADD start.sh /

CMD ["/start.sh"]

