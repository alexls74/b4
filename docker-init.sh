#!/bin/sh
set -e

echo "B4: configuring nftables..."

# Создаём таблицу если нет
nft list table ip nat >/dev/null 2>&1 || nft add table ip nat

# Создаём chain если нет
nft list chain ip nat postrouting >/dev/null 2>&1 || \
    nft add chain ip nat postrouting '{ type nat hook postrouting priority 100 ; }'

# Добавляем masquerade если нет
nft list chain ip nat postrouting | grep -q masquerade || \
    nft add rule ip nat postrouting masquerade

echo "B4: nft rules:"
nft list table ip nat

exec /usr/local/bin/b4 "$@"