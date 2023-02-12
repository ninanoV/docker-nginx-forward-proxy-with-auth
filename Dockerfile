FROM alpine:3.15

LABEL maintainer=kadangam<tjdgus4545@gmail.com>

WORKDIR /tmp

RUN apk update && \
    apk add --no-cache --virtual .build-deps \
    build-base \
    curl \
    perl \
    pcre \
    pcre-dev \
    libc6-compat \
    libressl-dev \
    make \
    openssl-dev \
    pcre-dev \
    zlib-dev \
    patch

RUN wget https://openresty.org/download/openresty-1.19.3.1.tar.gz && tar -zxvf openresty-1.19.3.1.tar.gz
RUN wget https://github.com/chobits/ngx_http_proxy_connect_module/archive/refs/tags/v0.0.4.tar.gz && tar -xzvf v0.0.4.tar.gz

WORKDIR ./openresty-1.19.3.1

RUN ./configure --with-pcre-jit --add-module=/tmp/ngx_http_proxy_connect_module-0.0.4
RUN patch -d build/nginx-1.19.3/ -p 1 < /tmp/ngx_http_proxy_connect_module-0.0.4/patch/proxy_connect_rewrite_1018.patch
RUN make && make install

COPY ./nginx.conf /usr/local/openresty/nginx/conf/
COPY ./pwd /tmp/

EXPOSE 3128

CMD ["/usr/local/openresty/nginx/sbin/nginx"]