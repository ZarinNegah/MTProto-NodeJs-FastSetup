#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#Check Root
[ $(id -u) != "0" ] && { echo "${CFAILURE}Error: You must be root to run this script${CEND}"; exit 1; }

# Delete Files
rm -rf /etc/proxy-secret
rm -rf /etc/proxy-port
rm -rf /etc/secret
cd ~/JSMTProxy
pm2 stop mtproxy.js -i max
cd ~
rm -rf MTProto-NodeJs-FastSetup-CentOS.sh
rm -rf MTProto-NodeJs-FastSetup-UD.sh
rm -rf JSMTProxy


clear
echo "Successful uninstallation！"

rm -rf UnInstall.sh
