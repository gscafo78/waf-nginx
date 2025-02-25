#!/bin/bash

# Insert the domain and email
read -p "Write the email: " email
read -p "write the domain: " domain

mkdir -p certbot/letsencrypt \
            waf/logs \
            www \
            waf/conf.d \
            waf/user-rules \
            certbot/logs

docker compose up -d waf-nginx

docker run --rm \
            -v $(pwd)/certbot/letsencrypt:/etc/letsencrypt \
            -v $(pwd)/www:/var/www/certbot \
            4ss078/certbot:latest certonly --webroot -w /var/www/certbot \
            --email $email --agree-tos --no-eff-email -d $domain

<<<<<<< HEAD
docker compose down waf-nginx
=======
docker compose down waf-nginx
>>>>>>> 9526e29c6e97b4a9a3007aa117b0a88cdf2ea99f
