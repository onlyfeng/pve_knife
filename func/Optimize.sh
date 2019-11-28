#!/bin/bash
RemoveLoginBrand() {
    if [ ! -f "/usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js.bak" ]; then
        cp -a /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js.bak
    fi
    sed -i "s#data.status !== 'Active'#false#g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
}

InstallBasicComponent() {
    apt install vim wget curl htop git axel aria2 apt-transport-https ca-certificates software-properties-common gnupg2 -y
}

ReplaceEnterpriseSource() {
    if [ -f "/etc/apt/sources.list.d/pve-enterprise.list"  ]; then
        mv /etc/apt/sources.list.d/pve-enterprise.list /etc/apt/sources.list.d/pve-enterprise.list.bak
        echo -e '#deb http://download.proxmox.com/debian/pve buster pve-no-subscription' > /etc/apt/sources.list.d/pve-community.list
        echo -e 'deb http://mirrors.ustc.edu.cn/proxmox/debian/pve/ buster pve-no-subscription\n' >> /etc/apt/sources.list.d/pve-community.list
    fi
    echo "Source replacement already complete"
}

ReplaceDebianUpdateRepo() {
    if [ ! -f "/etc/apt/sources.list.bak" ]; then
        apt install apt-transport-https -y
        cp -a /etc/apt/sources.list /etc/apt/sources.list.bak
        cat > /etc/apt/sources.list <<EOF
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ buster main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ buster main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-updates main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-updates main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-backports main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-backports main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security buster/updates main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security buster/updates main contrib non-free
EOF
    fi
}

AddReserveProxy() {
# Add For Proxmox Update
if [ `grep -c "89.31.125.19 download.proxmox.com" /etc/hosts` != '0' ]; then
	echo 'Done'
else
    echo "89.31.125.19 download.proxmox.com" >> /etc/hosts
fi
}

AddConfirmForDangerCommand() {
# Confirm For rm
if [ `grep -cx "alias rm='rm -i'" ~/.bashrc` != '0' ]; then
	echo 'Done'
else
    echo "alias rm='rm -i'" >> ~/.bashrc
fi
# Confirm For cp
if [ `grep -cx "alias cp='cp -i'" ~/.bashrc` != '0' ]; then
	echo 'Done'
else
    echo "alias cp='cp -i'" >> ~/.bashrc
fi
# Confirm For mv
if [ `grep -cx "alias mv='mv -i'" ~/.bashrc` != '0' ]; then
	echo 'Done'
else
    echo "alias mv='mv -i'" >> ~/.bashrc
fi
    source ~/.bashrc
}

SSHLoginAccelerate() {
    grep 'UseDNS' /etc/ssh/sshd_config
    grep 'GSSAPIAuthentication' /etc/ssh/sshd_config
    sed -i '/#UseDNS yes/aUseDNS no' /etc/ssh/sshd_config
    sed -i 's/GSSAPIAuthentication yes/GSSAPIAuthentication no/g' /etc/ssh/sshd_config
    grep 'UseDNS' /etc/ssh/sshd_config
    grep 'GSSAPIAuthentication' /etc/ssh/sshd_config

}

BoostNow() {
    echo '#####PVE Boost Script#####'
    echo "Let's do some choice"
while :; do echo
                read -e -p "Do you want to add Confirm For DangerCommand? [y/n]: " ChoiceConfirmDC
                if [[ ! ${ChoiceConfirmDC} =~ ^[y,n]$ ]]; then
                  echo "${CWARNING}input error! Please only input 'y' or 'n'"
                else
                  break
                fi
              done
while :; do echo
                read -e -p "Do you want to add Proxmox Update Accelerator? [y/n]: " ChoiceAccelerator
                if [[ ! ${ChoiceAccelerator} =~ ^[y,n]$ ]]; then
                  echo "${CWARNING}input error! Please only input 'y' or 'n'"
                else
                  break
                fi
              done
while :; do echo
                read -e -p "After replace files,Upgrade your system? [y/n]: " ChoiceUpdate
                if [[ ! ${ChoiceUpdate} =~ ^[y,n]$ ]]; then
                  echo "${CWARNING}input error! Please only input 'y' or 'n'"
                else
                  break
                fi
              done
    echo "That's all.Press any key to start...or Press Ctrl+C to cancel."
    char=$(get_char)
    ReplaceEnterpriseSource
    ReplaceDebianUpdateRepo
    RemoveLoginBrand
    UpdateRepo
    InstallBasicComponent
if [ "${ChoiceConfirmDC}" == 'y' ]; then
    AddConfirmForDangerCommand
fi
    SSHLoginAccelerate
if [ "${ChoiceAccelerator}" == 'y' ]; then
    AddReserveProxy
fi
if [ "${ChoiceUpdate}" == 'y' ]; then
    UpgradeSoftware
fi
    echo '#####PVE Boost Script#####'
    echo 'All Done Enjoy It'    
}