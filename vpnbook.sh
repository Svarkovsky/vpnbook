#!/bin/bash
##################################################################################
#    Name:
#      vpnbook.sh   v0.00000000000000000000000000000000000001           11.09.2017
#
#    Description:
#      The script lists the availiable free VPNs from
#      https://www.vpnbook.com. User can choose and 
#      connect to one of the 5 availiable VPN.
#
#    Requirements:
#      + openvpn client ( apt-get / yum install openvpn )
#
#      Script is using /bin/dash the closest POSIX implementation under Linux.
#      Tested under Debian Jessie, should work with most Linux distros.
#
#    Usage:
#      $ ./vpnbook.sh 
#
#    Author:
#       @sin-ok  ( https://github.com/Svarkovsky )
#
#    Donate: 
#       BTC: 12WFM3nJHmAHraiLhXn5Qw51fkNBweSKjR
#
##################################################################################

YELLOW='\033[1;33m'
RESET='\033[0m'
RED="\033[1;31m"       

####################################################
# Проверка наличия установленного openvpn
####################################################
openvpn_path=/usr/sbin/openvpn
if [ ! -e $openvpn_path ]; then 
   echo -e ${YELLOW}"MESSAGE:"${RED}" - ERROR - "
    echo -e ${YELLOW}"MESSAGE:"${RESET}" You need install openvpn or rename path..."
exit 1
fi

####################################################
# Скачиваем .ovpn файлы и получаем логин и пароль
####################################################
url='http://www.vpnbook.com/free-openvpn-account/VPNBook.com-OpenVPN-'
conf='VPNBook.com-OpenVPN-'
prc='Downloading and Extracting config file...'

echo -e "${YELLOW}Connecting to www.vpnbook.com...${RESET}"

AUTH="/tmp/$(basename $0).vpnbook.$$.tmp" 
echo "$(curl -s "https://www.vpnbook.com"   | grep -A 1 "Username: vpnbook" | tail -n 2 | cut -f2 -d " " | cut -f1 -d '<')"    >> $AUTH
echo "$(curl -s "https://www.vpnbook.com"  | grep -A 1 "Password:" | tail -n 2 | cut -d ':' -f2 | cut -d '<' -f1 | tr -d ' ')" >> $AUTH
username=$(sed -n -e 1p $AUTH) 
password=$(sed -n -e 2p $AUTH) 

echo -e " --------------------------------------------"
echo -e " Use this detail to authenticate to server..."
echo -e " Username: ${YELLOW}$username${RESET}"
echo -e " Password: ${YELLOW}$password${RESET}"
echo -e " --------------------------------------------"

#################################################### 
# Выбор
####################################################
echo "Choose your VPN Server connection destination: "
PS3='Please enter your choice: '
options=("USA1" "USA2" "CANADA" "EUROPE1" "EUROPE2" "GERMANY" "Quit")
select opt in "${options[@]}"
do
        case $opt in
                "USA1")
			sv='US1.zip'
                        echo "Connecting to USA1 VPN server..."
                        cd /tmp
			echo -e $prc
			wget -q -nv ${url}${sv} && unzip -qq ${conf}${sv}
                        /usr/sbin/openvpn --config /tmp/vpnbook-us1-tcp443.ovpn --auth-user-pass $AUTH
                        break
                        ;;
                "USA2")
			sv='US2.zip'
                        echo "$Connecting to USA2 VPN server..."
                        cd /tmp
			echo -e $prc
			wget -q -nv ${url}${sv} && unzip -qq ${conf}${sv}
                        /usr/sbin/openvpn --config /tmp/vpnbook-us2-tcp443.ovpn --auth-user-pass $AUTH
                        break
                        ;;
                "CANADA")
			sv='CA1.zip'
                        echo "$Connecting to Canada VPN server..."
			cd /tmp
			echo -e $prc
			wget -q -nv ${url}${sv} && unzip -qq ${conf}${sv}
                        /usr/sbin/openvpn --config /tmp/vpnbook-ca1-tcp443.ovpn --auth-user-pass $AUTH
                        break;
                        ;;
                "EUROPE1")
			sv='Euro1.zip'
                        echo "Connecting to Europe1 VPN server..."
                        cd /tmp
			echo -e $prc
			wget -q -nv ${url}${sv} && unzip -qq ${conf}${sv}
                        /usr/sbin/openvpn --config /tmp/vpnbook-euro1-tcp443.ovpn --auth-user-pass $AUTH
                        break
                        ;;
                "EUROPE2")
			sv='Euro2.zip'
                        echo "Connecting to Europe2 VPN server..."
                        cd /tmp
			echo -e $prc
			wget -q -nv ${url}${sv} && unzip -qq ${conf}${sv}
                        /usr/sbin/openvpn --config /tmp/vpnbook-euro2-tcp443.ovpn --auth-user-pass $AUTH
                        break
                        ;;
                "GERMANY")
			sv='DE1.zip'
                        echo "Connecting to Germany VPN server..."
                        cd /tmp
			echo -e $prc
			wget -q -nv ${url}${sv} && unzip -qq ${conf}${sv}
                        /usr/sbin/openvpn --config /tmp/vpnbook-de233-tcp443.ovpn --auth-user-pass $AUTH
                        break
                        ;;
                "Quit")
                        echo "Exiting..."
                        break
                        ;;

                *) echo Invalid option, try again.;;
        esac
done
