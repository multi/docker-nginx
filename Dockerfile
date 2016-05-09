# multi/nginx:1.10.0

FROM alpine:edge

ENV NGINX_VERSION=1.10.0 NGINX_RTMP_VERSION=1.1.7

RUN echo "@testing http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk update && \
    apk upgrade && \
    apk add geoip pcre libxslt gd && \
    apk add -t build-deps geoip-dev pcre-dev libxslt-dev gd-dev openssl openssl-dev linux-headers zlib-dev libstdc++ libgcc build-base patch && \
    cd /tmp && \
    wget https://github.com/arut/nginx-rtmp-module/archive/v${NGINX_RTMP_VERSION}.tar.gz && \
    tar zxf v${NGINX_RTMP_VERSION}.tar.gz && \
    wget http://nginx.org//download/nginx-${NGINX_VERSION}.tar.gz && \
    tar zxf nginx-${NGINX_VERSION}.tar.gz && \
    cd nginx-${NGINX_VERSION} && \
    ./configure \
      --prefix=/usr/share/nginx \
      --sbin-path=/usr/sbin/nginx \
      --conf-path=/etc/nginx/nginx.conf \
      --pid-path=/var/run/nginx/nginx.pid \
      --lock-path=/var/run/nginx/nginx.lock \
      --error-log-path=stderr \
      --http-log-path=/proc/self/fd/1 \
      --http-client-body-temp-path=/var/lib/nginx/tmp/client_body \
      --http-proxy-temp-path=/var/lib/nginx/tmp/proxy \
      --http-fastcgi-temp-path=/var/lib/nginx/tmp/fastcgi \
      --http-uwsgi-temp-path=/var/lib/nginx/tmp/uwsgi \
      --http-scgi-temp-path=/var/lib/nginx/tmp/scgi \
      --user=nginx \
      --group=nginx \
      --with-ipv6 \
      --with-file-aio \
      --with-pcre-jit \
      --with-mail \
      --with-mail_ssl_module \
      --with-http_addition_module \
      --with-http_auth_request_module \
      --with-http_dav_module \
      --with-http_degradation_module \
      --with-http_flv_module \
      --with-http_geoip_module \
      --with-http_xslt_module \
      --with-http_image_filter_module \
      --with-http_gunzip_module \
      --with-http_gzip_static_module \
      --with-http_mp4_module \
      --with-http_realip_module \
      --with-http_secure_link_module \
      --with-http_v2_module \
      --with-http_ssl_module \
      --with-http_slice_module \
      --with-http_stub_status_module \
      --with-http_sub_module \
      --with-threads \
      --with-stream \
      --with-stream_ssl_module \
      --add-module="/tmp/nginx-rtmp-module-${NGINX_RTMP_VERSION}" && \
    make -j$(grep -c '^processor' /proc/cpuinfo) && make INSTALLDIRS=vendor install && \
    install -d -m0755 /etc/nginx/conf.d && \
    install -d -m0755 /etc/nginx/default.d && \
    install -d -m0700 /var/lib/nginx && \
    install -d -m0700 /var/lib/nginx/tmp && \
    addgroup -S nginx && \
    adduser -S -D -G nginx -H -s /sbin/nologin nginx && \
    chown -R nginx:nginx /var/lib/nginx /var/run/nginx && \
    apk del --purge build-deps && \
    rm -rf /usr/share/man /tmp/* /var/cache/apk/* /usr/include

COPY nginx.conf /etc/nginx/nginx.conf

USER nginx

CMD ["nginx"]
