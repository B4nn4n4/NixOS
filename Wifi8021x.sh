#!/usr/bin/env bash

read -rp "SSID: " SSID
read -rp "Username: " USERNAME
read -rsp "Password: " PASSWORD
echo

IFACE=$(nmcli -t -f DEVICE,TYPE dev | awk -F: '$2=="wifi"{print $1; exit}')

CON_NAME="wifi-8021x-$SSID"

nmcli connection add type wifi ifname "$IFACE" con-name "$CON_NAME" ssid "$SSID"

nmcli connection modify "$CON_NAME" \
  wifi-sec.key-mgmt wpa-eap \
  802-1x.eap peap \
  802-1x.identity "$USERNAME" \
  802-1x.phase2-auth mschapv2 \
  802-1x.password "$PASSWORD"

nmcli connection up "$CON_NAME"

echo "Done."
