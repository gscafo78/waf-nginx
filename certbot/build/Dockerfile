# Usa l'immagine base ufficiale di Certbot
FROM certbot/certbot:latest

# Crea la directory per il webroot
RUN mkdir -p /var/www/certbot

# Esponi le porte necessarie per HTTP e HTTPS
EXPOSE 80 443

# Monta i volumi necessari per Certbot
VOLUME /etc/letsencrypt /var/lib/letsencrypt /var/www/certbot

# Imposta Certbot come entrypoint
ENTRYPOINT ["certbot"]

# Comando predefinito (può essere sovrascritto)
CMD ["--help"]