#!/bin/bash
source ./variables.sh
./configure_core.sh
./configure_nginx.sh
./configure_letsencrypt.sh
./configure_hostname.sh $REVERSE_PROXY_BRANDING
