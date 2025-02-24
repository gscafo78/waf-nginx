# Usa l'immagine base ufficiale di Certbot
FROM certbot/certbot

# Aggiorna e installa le dipendenze runtime per Certbot
RUN apk update && apk add --no-cache --virtual .certbot-deps \
        libffi \
        libssl3 \
        openssl \
        ca-certificates \
        binutils && \
    # Pulizia delle dipendenze temporanee
    apk del .certbot-deps

# Aggiungi comandi personalizzati
RUN mkdir -p /var/www/certbot 

EXPOSE 80 443
VOLUME /etc/letsencrypt /var/lib/letsencrypt /var/www/certbot

# Esegui Certbot o altre azioni come desiderato
ENTRYPOINT ["certbot"]