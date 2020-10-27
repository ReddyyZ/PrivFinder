#!/bin/bash

echo -e "PrivFinder - v1.0.0\n"

get_suid() {
    exploit=("/usr/bin/mount" "/usr/bin/vmware-user-suid-wrapper" "/usr/bin/passwd" "/usr/bin/python3" "/usr/bin/kismet_cap_linux_wifi")
    result=()

    suid=$(find / -perm /4000 2>/dev/null)
    readarray -t suid < <(echo "$suid")

    for i in "${suid[@]}";do
        for x in "${exploit[@]}";do
            if [[ "$i" == "$x" ]];then
                result=("${result[@]}" "${i}")
                break
            fi
        done
    done

    echo -e "Result: \n"
    echo "${result[@]}"
}

get_suid