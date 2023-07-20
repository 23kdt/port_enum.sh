#!/bin/bash

function exit_ctrc(){
    echo -e "\n\n[!] Saliendo...\n"
    tput cnorm                                 #volvemos a mostrar cursor en caso de salida fallida
    exit 1
}

trap exit_ctrc SIGINT

declare -a ports=( $(seq 1 65535) )                   #secuenciador para recorrer todos los puertos

function check_port(){
    (exec 3<> /dev/tcp/$1/$2) 2</dev/null

    if [ $? -eq 0 ]; then
        echo "[+] Host $1 - Port $2 (OPEN)"
    fi

    exec 3<&-
    exec 3<&-
}

tput civis                                              #ocultar cursor

if [ $1 ]; then
    for port in ${ports[@]}; do
        check_port $1 $port &
    done
else
    echo -e "\n[!] Uso: $0 <ip-address>\n"              #Info si introducimos mal la orden
    tput cnorm
    exit 1
fi

wait

tput cnorm
