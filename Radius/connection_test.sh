#!/bin/bash

HOST=""
PORT=1812
SECRET=""
USER=""
PASS=""
METHOD="mschap"

usage() {
    echo "Usage: $0 -s secret -u user [-P pass] [-h host] [-p port] [-m method]"
    exit 1
}

while getopts "s:u:P:h:p:m:" o; do
    case $o in
        s) SECRET=$OPTARG ;;  u) USER=$OPTARG ;;  P) PASS=$OPTARG ;;  h) HOST=$OPTARG ;;
        p) PORT=$OPTARG ;;   m) METHOD=$OPTARG ;;
        *) usage ;;
    esac
done
[[ -z $SECRET || -z $USER ]] && usage
[[ -z $PASS ]] && read -s -p "Password for $USER: " PASS && echo


command -v radtest >/dev/null || { echo "Install freeradius-client"; exit 1; }

if [[ $METHOD == peap ]]; then
    command -v eapol_test >/dev/null || { echo "Install wpa_supplicant"; exit 1; }
fi

if [[ $METHOD == mschap ]]; then
    echo "Testing MSCHAPv2 on $HOST:$PORT"
    radtest -x "$USER" "$PASS" "${HOST}:${PORT}" 0 "$SECRET"
else
    tmp=$(mktemp)
    cat > "$tmp" <<EOF
network={
key_mgmt=IEEE8021X
eap=PEAP
identity="$USER"
password="$PASS"
phase2="auth=MSCHAPV2"
}
EOF
    eapol_test -c "$tmp" -a "$HOST" -s "$SECRET" -o testing
    rm -f "$tmp"
fi
