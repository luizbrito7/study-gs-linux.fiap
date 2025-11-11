#!/bin/bash

# colors
COLOR_DEFAULT="\e[0m"
COLOR_BLUE="\e[1;34m"
COLOR_GREEN="\e[1;32m"
COLOR_RED="\e[1;31m"
COLOR_YELLOW="\e[1;33m"

# utility functions
log_info() { echo -e "${COLOR_BLUE}$1${COLOR_DEFAULT}"; }
log_success() { echo -e "${COLOR_GREEN}$1${COLOR_DEFAULT}"; }
log_error() { echo -e "${COLOR_RED}$1${COLOR_DEFAULT}"; }
log_warn() { echo -e "${COLOR_YELLOW}$1${COLOR_DEFAULT}"; }

check_exit_code() {
    if [ $1 -ne 0 ]; then
        log_error "$2 failed, exit code: $1"
        exit 1
    else
        log_success "$2 success"
    fi
}

# ===============
# network environment variables
# ===============

IP_FIXO="192.168.0.201"
NETMASK="255.255.255.0"
NIC="enp0s8"

log_warn "Configuração IP fixo NIC Host-Only: $NIC"

log_info "Configurando IP $IP_FIXO..."
ifconfig "$NIC" "$IP_FIXO" netmask "$NETMASK" 
check_exit_code $? "Configurar IP"

# ===============
# webserver environment variables
# ===============

APACHE_PATH="/var/www/html"
WEB_SITE_URL="https://html5up.net/paradigm-shift/download"


log_info "Instalando dependências..."
yum install -y httpd wget unzip bind
check_exit_code $? "Instalar dependências"


log_info "Baixando e configurando website..."
systemctl enable --now httpd 
check_exit_code $? "Iniciar serviço httpd"

rm -rf "$APACHE_PATH"/*

log_info "Baixando website..."
wget -q "$WEB_SITE_URL" -O /tmp/site.zip && unzip /tmp/site.zip -d $APACHE_PATH
check_exit_code $? "Download website"

log_success "Webserver configurado com sucesso!"



