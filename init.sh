#!/bin/bash

# Chiedi all'utente di inserire l'email e il dominio
read -p "Inserisci la tua email: " email
read -p "Inserisci il dominio: " domain

mkdir -p certbot/letsencrypt \
            waf/logs \
            www \
            waf/conf.d \
            certbot/logs

docker-compose up -d waf-nginx

docker run --rm \
            -v $(pwd)certbot/letsencrypt:/etc/letsencrypt \
            -v $(pwd)/www:/var/www/certbot \
            4ss078/certbot:latest certonly --webroot -w /var/www/certbot \
            --email $email --agree-tos --no-eff-email -d $domain

docker-compose down waf-nginx