#!/bin/sh
set -e

cd /data

WRITEFREELY=/writefreely/writefreely

echo "--- Starting custom entrypoint script ---"

if [ ! -f "./config.ini" ]; then
    echo "config.ini not found. Generating from environment variables..."
    cat > ./config.ini <<EOF
[server]
hidden_host          =
port                 = 8080
bind                 = 0.0.0.0
tls_cert_path        =
tls_key_path         =
templates_parent_dir = /data
static_parent_dir    = /data
pages_parent_dir     = /data
keys_parent_dir      =

[database]
type = mysql
username = ${MYSQL_USER}
password = ${MYSQL_PASSWORD}
database = ${MYSQL_DATABASE}
host = mysql
port = 3306

[app]
title             = My Blog
description       = A place for my thoughts.
site_name         = A Writefreely blog
site_description  =
host              = ${WRITEFREELY_HOST}
theme             = write
disable_js        = false
webfonts          = true
landing           =
single_user       = false
open_registration = false
min_username_len  = 3
max_blogs         = 1
federation        = true
public_stats      = false
private           = false
local_timeline    = false
user_invites      =
EOF
    echo "config.ini generated successfully."
else
    echo "config.ini already exists. Skipping generation."
fi

echo "Initializing / Migrating database..."
${WRITEFREELY} db init
echo "Database is up-to-date."

if [ ! -e ./keys/email.aes256 ]; then
    echo "Keys not found. Generating new keys..."
    ${WRITEFREELY} keys generate
fi

echo "Checking for admin user creation..."
if [ -n "${WRITEFREELY_ADMIN_USER}" ] && [ -n "${WRITEFREELY_ADMIN_PASSWORD}" ]; then
    echo "Admin user environment variables are set. Attempting to create admin user..."
    if ${WRITEFREELY} --create-admin "${WRITEFREELY_ADMIN_USER}:${WRITEFREELY_ADMIN_PASSWORD}"; then
        echo "Admin user created successfully (or already exists)."
    else
        EXIT_CODE=$?
        echo "Error: --create-admin command failed with exit code ${EXIT_CODE}."
    fi
fi

echo "Starting WriteFreely application..."
exec ${WRITEFREELY}
