# Usa Debian come base con strumenti di compilazione
FROM debian:bookworm-slim

# Definisci la versione di Nginx come argomento di build
ARG NGINX_VERSION=1.25.4
ENV NGINX_VERSION=${NGINX_VERSION}

# Installa pacchetti necessari per la compilazione
RUN apt-get update && apt-get install -y \
    build-essential \
    libpcre3 \
    libpcre3-dev \
    libssl-dev \
    zlib1g-dev \
    libgeoip-dev \
    libgd-dev \
    libperl-dev \
    libxslt1-dev \
    libxml2-dev \
    libmailutils-dev \
    libcurl4-openssl-dev \
    libyajl-dev \
    wget \
    git \
    automake \
    autoconf \
    libtool \
    curl \
    libreadline-dev \          
    libncurses5-dev \          
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Crea le directory necessarie
RUN mkdir -p /etc/nginx/modsec/rules \
             /etc/nginx/modsec/user-rules \
             /var/www/certbot \
             /etc/nginx/modules-enabled \
             /etc/nginx/conf.d \
             /var/lib/nginx/body

# Clona e compila ModSecurity v3
WORKDIR /usr/src
RUN git clone --depth 1 -b v3/master --single-branch https://github.com/SpiderLabs/ModSecurity.git
WORKDIR /usr/src/ModSecurity
RUN git submodule init && git submodule update
RUN ./build.sh && ./configure && make -j$(nproc) && make install

# Clona e compila il modulo Nginx per ModSecurity
WORKDIR /usr/src
RUN git clone --depth 1 https://github.com/SpiderLabs/ModSecurity-nginx.git

# Scarica e compila Nginx con il modulo ModSecurity
WORKDIR /usr/src
RUN wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
    tar -xvzf nginx-${NGINX_VERSION}.tar.gz

WORKDIR /usr/src/nginx-${NGINX_VERSION}

# Configura Nginx con i moduli richiesti
RUN ./configure \
    --with-cc-opt="-g -O2 -ffile-prefix-map=/build/nginx-AoTv4W/nginx-${NGINX_VERSION}=. -fstack-protector-strong -Wformat -Werror=format-security -fPIC -Wdate-time -D_FORTIFY_SOURCE=2" \
    --with-ld-opt="-Wl,-z,relro -Wl,-z,now -fPIC -L/usr/local/lib -Wl,-rpath,/usr/local/lib" \
    --prefix=/usr/share/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --http-log-path=/var/log/nginx/access.log \
    --error-log-path=stderr \
    --lock-path=/var/lock/nginx.lock \
    --pid-path=/run/nginx.pid \
    --modules-path=/usr/lib/nginx/modules \
    --http-client-body-temp-path=/var/lib/nginx/body \
    --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
    --http-proxy-temp-path=/var/lib/nginx/proxy \
    --http-scgi-temp-path=/var/lib/nginx/scgi \
    --http-uwsgi-temp-path=/var/lib/nginx/uwsgi \
    --with-compat \
    --with-debug \
    --with-pcre-jit \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_realip_module \
    --with-http_auth_request_module \
    --with-http_v2_module \
    --with-http_dav_module \
    --with-http_slice_module \
    --with-threads \
    --with-http_addition_module \
    --with-http_flv_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_mp4_module \
    --with-http_random_index_module \
    --with-http_secure_link_module \
    --with-http_sub_module \
    --with-mail_ssl_module \
    --with-stream_ssl_module \
    --with-stream_ssl_preread_module \
    --with-stream_realip_module \
    --with-http_geoip_module=dynamic \
    --with-http_image_filter_module=dynamic \
    --with-http_perl_module=dynamic \
    --with-http_xslt_module=dynamic \
    --with-mail=dynamic \
    --with-stream=dynamic \
    --with-stream_geoip_module=dynamic \
    --add-dynamic-module=../ModSecurity-nginx && \
    make -j$(nproc) && \
    make install

# Copia i moduli compilati nella directory appropriata
RUN mkdir -p /usr/lib/nginx/modules && \
    cp /usr/src/nginx-${NGINX_VERSION}/objs/*.so /usr/lib/nginx/modules/

# Carica i moduli dinamici
RUN mkdir -p /usr/share/nginx/modules-available && \
    echo "load_module /usr/lib/nginx/modules/ngx_http_modsecurity_module.so;" > /usr/share/nginx/modules-available/80-mod-http-modsecurity.conf

# Crea i collegamenti simbolici per i moduli
RUN ln -s /usr/share/nginx/modules-available/* /etc/nginx/modules-enabled/

# Crea il symlink per avviare Nginx facilmente
RUN [ ! -e /usr/sbin/nginx ] && ln -s /usr/share/nginx/sbin/nginx /usr/sbin/nginx || true

WORKDIR /usr/src
RUN wget https://github.com/crowdsecurity/cs-nginx-bouncer/releases/download/v1.0.8/crowdsec-nginx-bouncer.tgz
RUN tar -xvzf crowdsec-nginx-bouncer.tgz
WORKDIR /usr/src/crowdsec-nginx-bouncer-v1.0.8
RUN chmod +x install.sh
RUN ./install.sh

WORKDIR /usr/src
# Clona le regole OWASP CRS durante il build
RUN git clone https://github.com/coreruleset/coreruleset.git

# Copia le configurazioni personalizzate in una directory temporanea
COPY ./default.conf ./nginx_template.conf ./modsec-config/main.conf ./modsec-config/modsecurity.conf /usr/src/modsec-config/

# Aggiungi l'entrypoint e imposta i permessi
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Esponi le porte 80 (HTTP) e 443 (HTTPS)
EXPOSE 80 443

VOLUME /var/www/certbot /etc/nginx/conf.d /var/log/nginx/ /etc/nginx/modsec

# Imposta l'entrypoint e il comando di default
ENTRYPOINT ["/entrypoint.sh"]

# Avvia Nginx in modalità foreground
CMD ["nginx", "-g", "daemon off;"]
