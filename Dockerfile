FROM alpine:3.10 as builder

ENV VARNISH_VERSION=6.2
ENV QUERYFILTER_VERSION=v1.0.0

RUN apk update; apk add varnish varnish~${VARNISH_VERSION} curl autoconf libtool pkgconfig automake varnish-dev make python3

RUN curl -L https://github.com/nytimes/libvmod-queryfilter/archive/${QUERYFILTER_VERSION}.tar.gz -o /tmp/queryfilter.tar.gz && cd /tmp/ && tar -xzf queryfilter.tar.gz

RUN cd /tmp/libvmod-queryfilter-* && ./autogen.sh && ./configure && make && make check

FROM alpine:3.10

ENV VARNISH_VERSION=6.2

RUN apk update; apk add varnish varnish~${VARNISH_VERSION} curl

COPY --from=builder /tmp/libvmod-queryfilter-*/src/.libs/libvmod_queryfilter.so /usr/lib/varnish/vmods/libvmod_queryfilter.so
COPY --from=builder /tmp/libvmod-queryfilter-*/src/.libs/libvmod_queryfilter.lai /usr/lib/varnish/vmods/libvmod_queryfilter.la

USER varnish

ADD start.sh /

CMD ["/start.sh"]

