# Waf-nginx

## Overview
`waf-nginx` is a Docker-based project that sets up a Web Application Firewall (WAF) using Nginx. This project includes configurations for SSL certificates using Certbot.

## Prerequisites
- Docker
- Docker Compose

## Setup
1. Clone the repository:
    ```sh
    git clone https://github.com/gscafo78/waf-nginx
    cd waf-nginx
    ```

2. Run the initialization script:
    ```sh
    ./init.sh
    ```

    You will be prompted to enter your email and domain.

## Directory Structure
- `certbot/letsencrypt`: Stores the SSL certificates.
- `waf/logs`: Stores the WAF logs.
- `www`: Web root directory for Certbot.
- `waf/conf.d`: Configuration files for Nginx.
- `certbot/logs`: Logs for Certbot.

## Usage
To start the WAF and Nginx services, run:
```sh
docker-compose up -d
