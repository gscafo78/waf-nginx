#!/bin/bash

# Insert the domain and email
read -p "Write the email: " email
read -p "write the domain: " domain

mkdir -p $(pwd)/certbot/letsencrypt \
            $(pwd)/waf/logs \
            $(pwd)/www \
            $(pwd)/waf/conf.d \
            $(pwd)/waf/user-rules \
            $(pwd)/certbot/logs

docker compose up -d waf-nginx

docker run --rm \
            -v $(pwd)/certbot/letsencrypt:/etc/letsencrypt \
            -v $(pwd)/www:/var/www/certbot \
            4ss078/certbot:latest certonly --webroot -w /var/www/certbot \
            --email $email --agree-tos --no-eff-email -d $domain

docker compose down waf-nginx
