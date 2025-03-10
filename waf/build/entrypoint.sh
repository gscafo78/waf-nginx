#!/bin/sh
set -e

# Crea le directory necessarie se non esistono
mkdir -p /etc/nginx/modsec/rules \
         /etc/nginx/modsec/user-rules \
         /etc/nginx/modules-enabled \
         /var/lib/nginx/body

# Copia le regole OWASP CRS se non presenti
if [ ! -f "/etc/nginx/modsec/crs-setup.conf" ]; then
    echo "Inizializzazione regole OWASP CRS..."
    cp -r /usr/src/coreruleset/rules /etc/nginx/modsec/
    cp /usr/src/coreruleset/crs-setup.conf.example /etc/nginx/modsec/crs-setup.conf
fi

# Copia le configurazioni base se non presenti
if [ ! -f "/etc/nginx/nginx.conf" ]; then
    cp /usr/src/modsec-config/nginx_template.conf /etc/nginx/nginx.conf
fi

if [ ! -f "/etc/nginx/conf.d/default.conf" ]; then
    cp /usr/src/modsec-config/default.conf /etc/nginx/conf.d/
fi

if [ ! -f "/etc/nginx/modsec/main.conf" ]; then
    cp /usr/src/modsec-config/main.conf /etc/nginx/modsec/
fi

if [ ! -f "/etc/nginx/modsec/modsecurity.conf" ]; then
    cp /usr/src/modsec-config/modsecurity.conf /etc/nginx/modsec/
fi

# Verifica esistenza file di configurazione nginx
if [ ! -f "/etc/nginx/nginx.conf" ]; then
    echo "Errore: file di configurazione nginx.conf non trovato!"
    exit 1
fi

# Fix permessi per le directory principali
chown -R www-data:www-data /var/log/nginx /var/lib/nginx

# Esegui il comando principale
exec "$@"