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

echo -e "[${Green}*${White}]PrivFinder - v1.0.0\n"

get_suid() {
    exploit=($(cat /mnt/c/Projetos/Tools/PrivFinder/vulns/suid.lst))
    suid=($(find /root -perm /4000 2>/dev/null))
    result=()

    for i in $suid;do
        for x in "${exploit[@]}";do
            if [[ "$i" == *"$x"* ]] ;then
                result=("${result[@]}" "${i}")
                break
            fi
        done
    done

    echo -e "Result: \n"
    echo "${result[@]}"
}

get_capabilites() {
    exploit=($(cat vulns/capabilites.lst))
    capabilites=($(getcap -r / 2>/dev/null))
    result=()

    for i in "${capabilites[@]}";do
        for x in "${exploit[@]}";do
            if [[ "$i" == *"$x"* ]];then
                result=("${result[@]}" "${i}")
                break
            fi
        done
    done

    echo -e "Result: \n"
    echo "${result[@]}"
}