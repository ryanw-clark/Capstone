#!/bin/sh
#
# ufetch-crux - tiny system info for crux
#
# Copyright (c) 2018 Joe Schillinger <me@schil.li>
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

# ###
# modified
#

# 1. host
host="$(hostname)"

# 2. os
os="$(grep PRETTY_NAME /etc/os-release | cut -d'=' -f2- | tr -d '"')"

# 3. kernel
kernel="$(uname -r | sed 's/\([0-9]*\.[0-9]*\.[0-9]*\)-\([0-9]*\).*/\1-\2/') $(uname -m)"

# 4. selinux
if sestatus | grep -q "SELinux status: *enabled"; then
    selinux="enabled; mode: $(getenforce)"
else
    selinux="SELinux is disabled"
fi

# 5. systemd
total_units=$(systemctl list-units --all | grep "loaded units" | awk '{print $1}')
failed_units=$(systemctl --failed | grep "loaded units" | awk '{print $1}')
if [ "$failed_units" -gt 0 ]; then
    status="failed"
else
    status="running"
fi
systemd="$status ($failed_units/$total_units failed)"

# 6. packages
packages="$(rpm -qa | wc -l)"

# 7. uptime
uptime="$(uptime -p | sed 's/up //')"

# shell="$(basename "${SHELL}")"

# probably don't change these
if [ -x "$(command -v tput)" ]; then
    bold="$(tput bold 2> /dev/null)"
    black="$(tput setaf 0 2> /dev/null)"
    red="$(tput setaf 1 2> /dev/null)"
    green="$(tput setaf 2 2> /dev/null)"
    yellow="$(tput setaf 3 2> /dev/null)"
    blue="$(tput setaf 4 2> /dev/null)"
    magenta="$(tput setaf 5 2> /dev/null)"
    cyan="$(tput setaf 6 2> /dev/null)"
    white="$(tput setaf 7 2> /dev/null)"
    reset="$(tput sgr0 2> /dev/null)"
fi

# change these
lc="${reset}${bold}${red}" # labels
nc="${reset}${bold}${red}" # user and hostname
ic="${reset}"              # info
c0="${reset}${red}"        # first color
c1="${reset}${red}"        # second color
c2="${reset}${red}"        # third color

cat <<EOF

${c0}      ___     ${nc}${USER}${ic}@${nc}${host}${reset}
${c0}     (${c1}.· ${c0}|    ${lc}OS:       ${ic}${os}${reset}
${c0}     (${c2}<> ${c0}|    ${lc}KERNEL:   ${ic}${kernel}${reset}
${c0}    / ${c1}__  ${c0}\\   ${lc}SELINUX:  ${ic}${selinux}${reset}
${c0}   ( ${c1}/  \\ ${c0}/|  ${lc}SYSTEMD:  ${ic}${systemd}${reset}
${c2}  _${c0}/\\ ${c1}__)${c0}/${c2}_${c0})  ${lc}UPTIME:   ${ic}${uptime}${reset}
${c2}  \/${c0}-____${c2}\/   ${lc}PACKAGES: ${ic}${packages}${reset}

EOF