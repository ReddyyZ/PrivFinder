#!/bin/bash

# readarray -t exploit < <(echo "$exploit")
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

__version__="v1.0.0"

# echo -e "${Yellow}[*]${White}PrivFinder - v1.0.0\n"
echo -e """
d8888b. d8888b. d888888b db    db d88888b d888888b d8b   db d8888b. d88888b d8888b. 
88  \`8D 88  \`8D   \`88'   88    88 88'       \`88'   888o  88 88  \`8D 88'     88  \`8D 
88oodD' 88oobY'    88    Y8    8P 88ooo      88    88V8o 88 88   88 88ooooo 88oobY' 
88~~~   88\`8b      88    8b  d8' 88~~~      88    88 V8o88 88   88 88~~~~~ 88\`8b   
88      88 \`88.   .88.    \`8bd8'  88        .88.   88  V888 88  .8D 88.     88 \`88. 
88      88   YD Y888888P    YP    YP      Y888888P VP   V8P Y8888D' Y88888P 88   YD 

Version: ${__version__}

Github: https://github.com/ReddyyZ/PrivFinder
By: ReddyyZ

${Cyan}[*]${White}Starting...
"""

function get_suid() {
    exploit=($(cat vulns/suid.lst))
    suid=$(find /root -perm /4000 2>/dev/null)
    result=()

    for i in $suid;do
        for x in "${exploit[@]}";do
            if [[ "$i" == *"$x"* ]] ;then
                result=("${result[@]}" "${i}")
                break
            fi
        done
    done

    suid_r=("${result[@]}")
}

function get_capabilites() {
    exploit=($(cat vulns/capabilites.lst))
    capabilites=($(getcap -r /root 2>/dev/null))
    result=()

    for i in "${capabilites[@]}";do
        for x in "${exploit[@]}";do
            if [[ "$i" == *"$x"* ]];then
                result=("${result[@]}" "${i}")
                break
            fi
        done
    done

    capabilites_r=("${result[@]}")
}

function print_results() {

    ########################################################
    ##########################SUID##########################
    ########################################################

    if [[ -z $suid_r ]];then
        echo -e "${Red}[-]${White}Not found any file with SUID bit\n"
    else
        echo -e "${Cyan}[*]${White}Files with SUID Bit...\n"
    fi

    for i in "${suid_r[@]}";do
        echo -e "${Green}[+]${White}FOUND: ${i}"
        

        readarray -d / -t strarr <<< "$i"
        dt=${strarr[-1]//$'\n'/}
        
        # echo -e "${Green}[*]${White}$(jq -r .${dt}[0] exploits/suid.json)"
        # echo -e "${Green}[*]${White}$(jq -r .${dt}[1] exploits/suid.json)\n"
        echo -e "   $(jq -r .${dt}[0] exploits/suid.json)"
        echo -e "   $(jq -r .${dt}[1] exploits/suid.json)\n"
    done

    ########################################################
    ######################CAPABILITES#######################
    ########################################################

    if [[ -z $capabilites_r ]];then
        echo -e "${Red}[-]${White}Not found any file with capabilites permission"
    else
        echo -e "${Cyan}[*]${White}Files with Capabilites permission...\n"
    fi

    for i in "${capabilites_r[@]}";do
        echo -e "${Red}[!]${White}FOUND: ${i}"
        

        readarray -d / -t strarr <<< "$i"
        dt=${strarr[-1]//$'\n'/}
        
        echo -e "${Green}[*]${White}$(jq -r .${dt}[0] exploits/capabilites.json)"
        echo -e "${Green}[*]${White}$(jq -r .${dt}[1] exploits/capabilites.json)\n"
    done

}

function main() {
    echo -e "${Cyan}[*]${White}Scanning for files with SUID bit"
    get_suid # Scan for files with SUID bit

    echo -e "${Cyan}[*]${White}Scanning for files with capabilites permission\n"
    get_capabilites # Scan for files with capabilites permission
    print_results
}

main