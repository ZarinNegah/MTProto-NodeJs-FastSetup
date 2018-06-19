##################################################
# Anything wrong? Find me via telegram:@MTP_2018 #
##################################################

#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#Check Root
[ $(id -u) != "0" ] && { echo "${CFAILURE}Error: You must be root to run this script${CEND}"; exit 1; }

#Check OS
if [ -n "$(grep 'Aliyun Linux release' /etc/issue)" -o -e /etc/redhat-release ]; then
  OS=CentOS
  [ -n "$(grep ' 7\.' /etc/redhat-release)" ] && CentOS_RHEL_version=7
  [ -n "$(grep ' 6\.' /etc/redhat-release)" -o -n "$(grep 'Aliyun Linux release6 15' /etc/issue)" ] && CentOS_RHEL_version=6
  [ -n "$(grep ' 5\.' /etc/redhat-release)" -o -n "$(grep 'Aliyun Linux release5' /etc/issue)" ] && CentOS_RHEL_version=5
elif [ -n "$(grep 'Amazon Linux AMI release' /etc/issue)" -o -e /etc/system-release ]; then
  OS=CentOS
  CentOS_RHEL_version=6
else
  echo "${CFAILURE}Does not support this OS, Please contact the author! ${CEND}"
  kill -9 $$
fi

# Detect CPU Threads
THREAD=$(grep 'processor' /proc/cpuinfo | sort -u | wc -l)

# Define the Terminal Color
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

# Print Welcome Message
clear
echo "---------------------------------------------"
echo "  Install MTProto For Telegram with NodeJs"
echo "  Author: ZarinNegah"
echo "  URL: http://Fastsetup.MTProtoServer.ir/"
echo "  Telegram: https://t.me/mtp_2018"
echo "---------------------------------------------"
echo ""


if [ -f "/etc/secret" ]; then 
	IP=$(curl -4 -s ip.sb)
	SECRET=$(cat /etc/secret)
	PORT=$(cat /etc/proxy-port)
	echo "MTProxy Installed！"
        echo "Server IP： ${IP}"
        echo "Port：      ${PORT}"
        echo "Secret：    ${SECRET}"
        echo "TAG：       Not Support NodeJs"
        echo ""
        echo -e "TG Proxy link：${green}https://t.me/proxy?server=${IP}&port=${uport}&secret=${SECRET}${plain}"
        echo ""
        echo -e "TG Proxy link：${green}tg://proxy?server=${IP}&port=${uport}&secret=${SECRET}${plain}"
	echo ""
	exit 0
fi

# Firewalld
if [[ ${OS} == CentOS ]]; then
	if [[ $CentOS_RHEL_version == 7 ]]; then
	        yum install firewalld -y
                systemctl enable firewalld
                systemctl start firewalld
                systemctl status firewalld
        elif [[ $CentOS_RHEL_version == 6 ]]; then
	        yum install firewalld -y
	fi
fi

# Enter the Proxy Port
read -p "Inout the Port for running MTProxy [Default: 2082]： " uport
if [[ -z "${uport}" ]];then
	uport="2082"
fi

if [ ${OS} == CentOS ]; then
  yum update -y
  yum install wget gcc gcc-c++ flex bison make bind bind-libs bind-utils epel-release iptables-services openssl openssl-devel firewalld perl quota libaio libcom_err-devel libcurl-devel tar diffutils nano dbus.x86_64 db4-devel cyrus-sasl-devel perl-ExtUtils-Embed.x86_64 cpan vim-common screen libtool perl-core zlib-devel htop git git-core curl sudo -y
  yum groupinstall "Development Tools" -y
  curl -sL http://nsolid-rpm.nodesource.com/nsolid_setup_3.x | sudo bash -
  sudo yum -y install nsolid-carbon nsolid-console
  npm install npm@latest -g
  npm install pm2@latest -g
fi

# Get Native IP Address
IP=$(curl -4 -s ip.sb)

# Download MTProxy project source code
if [[ ${OS} == CentOS ]]; then
	if [[ $CentOS_RHEL_version == 7 ]]; then
		git clone https://github.com/FreedomPrevails/JSMTProxy
        elif [[ $CentOS_RHEL_version == 6 ]]; then
	        git clone git://github.com/FreedomPrevails/JSMTProxy
	fi
fi
cd JSMTProxy

# Generate a Key
echo "${uport}" > /etc/proxy-port
head -c 16 /dev/urandom | xxd -ps > /etc/secret
SECRET=$(cat /etc/secret)
UPORT=$(cat /etc/proxy-port)
echo -e "{ \n  'port':${UPORT}, \n  'secret':'${SECRET}' \n}" > config.json
echo -e '{ \n  "port":'${UPORT}', \n  "secret":"'${SECRET}'" \n}' > config.json

# Setting Up a Firewall
if [ ! -f "/etc/iptables.up.rules" ]; then 
    iptables-save > /etc/iptables.up.rules
fi

if [[ ${OS} == CentOS ]]; then
	if [[ $CentOS_RHEL_version == 7 ]]; then
		
        if [ $? -eq 0 ]; then
	        firewall-cmd --permanent --add-port=${uport}/tcp
		firewall-cmd --permanent --add-port=${uport}/udp
	        firewall-cmd --reload
	else
		iptables-restore < /etc/iptables.up.rules
		iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport $uport -j ACCEPT
    		iptables -I INPUT -m state --state NEW -m udp -p udp --dport $uport -j ACCEPT
		iptables-save > /etc/iptables.up.rules
		fi
	else
		iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport $uport -j ACCEPT
    	        iptables -I INPUT -m state --state NEW -m udp -p udp --dport $uport -j ACCEPT
		/etc/init.d/iptables save
		/etc/init.d/iptables restart
	fi
fi


# Set Boot From Start and Start MTProxy
if [[ ${OS} == CentOS ]]; then
	if [[ $CentOS_RHEL_version == 7 ]]; then
	        cd ~/JSMTProxy
		pm2 start mtproxy.js -i max
                pm2 save
                pm2 startup centos
        elif [[ $CentOS_RHEL_version == 6 ]]; then
	        cd ~/JSMTProxy
	        pm2 start mtproxy.js -i max
                pm2 save
                pm2 startup
	fi
fi

# Display Service Information
clear
echo "MTProxy Successful Installation！"
echo "Server IP： ${IP}"
echo "Port：      ${uport}"
echo "Secret：    ${SECRET}"
echo "TAG：       Not Support NodeJs"
echo ""
echo -e "TG Proxy link：${green}https://t.me/proxy?server=${IP}&port=${uport}&secret=${SECRET}${plain}"
echo ""
echo -e "TG Proxy link：${green}tg://proxy?server=${IP}&port=${uport}&secret=${SECRET}${plain}"
echo ""
