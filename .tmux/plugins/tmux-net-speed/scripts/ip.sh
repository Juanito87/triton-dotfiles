#!/bin/bash -

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/helpers.sh"

main()
{
    local format=$(get_tmux_option @net_ip_format "IP(%s): %10s")
    local interfaces=$(get_tmux_option @net_speed_interfaces "")
    local ip=$(ip a s $interfaces | awk -F'[/ ]+' '/inet / {print $3}')
    printf "$format" "$interfaces" "$ip"
}
main
