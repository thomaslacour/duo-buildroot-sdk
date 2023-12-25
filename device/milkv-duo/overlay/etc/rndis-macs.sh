#!/bin/ash

RNDIS_USB="/tmp/usb/usb_gadget/cvitek/functions/rndis.usb0"
MAC_FILE="/etc/rndis-macs.conf"

generate_random_mac() {
    printf "02:%02x:%02x:%02x:%02x:%02x\n" $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256))
}

# check if the MAC address file exists and has exactly two lines
if [[ -f "$MAC_FILE" ]] && [[ $(wc -l < "$MAC_FILE") -eq 2 ]]; then
    # read the two MAC addresses from the file
    IFS=$'\n' read -d '' -r -a macs < "$MAC_FILE"
    dev="${macs[0]}"
    host="${macs[1]}"
    echo "using existing MAC addresses:"
else
    # generate two new MAC addresses and store them in the file
    echo "generating new MAC addresses:"
    dev=$(generate_random_mac)
    host=$(generate_random_mac)
    echo "$dev" > "$MAC_FILE"
    echo "$host" >> "$MAC_FILE"
fi
echo "dev_addr: $dev"
echo "host_addr: $host"
echo "$dev" > "$RNDIS_USB"/dev_addr
echo "$host" > "$RNDIS_USB"/host_addr
