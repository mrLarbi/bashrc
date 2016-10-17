#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

shopt -s extglob
alias ls='ls --color=auto'
PS1='\[\033[01;31m\]♬ \[\033[01;34m\]\u\[\033[01;31m\]☯\[\033[01;34m\]\h\w\[\033[01;31m\]♬ \[\033[01;34m\]➔'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

function proxy_on() {
    export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"

    if (( $# > 0 )); then
        valid=$(echo $@ | sed -n 
's/\([0-9]\{1,3\}.\)\{4\}:\([0-9]\+\)/&/p')
        if [[ $valid != $@ ]]; then
            >&2 echo "Invalid address"
            return 1
        fi

        export http_proxy="http://$1/"
        export https_proxy=$http_proxy
        export ftp_proxy=$http_proxy
        export rsync_proxy=$http_proxy
        echo "Proxy environment variable set."
        return 0
    fi

    echo -n "username: "; read username
    if [[ $username != "" ]]; then
        echo -n "password: "
        read -es password
        local pre="$username:$password@"
    fi

    echo -n "server: "; read server
    echo -n "port: "; read port
    export http_proxy="http://$pre$server:$port/"
    export https_proxy="https://$pre$server:$port/"
    export ftp_proxy="ftp://$pre$server:$port/"
    export rsync_proxy=$http_proxy
    export HTTP_PROXY=$http_proxy
    export HTTPS_PROXY=$http_proxy
    export FTP_PROXY=$http_proxy
    export RSYNC_PROXY=$http_proxy

    gsettings set org.gnome.system.proxy mode 'manual' 
    gsettings set org.gnome.system.proxy.http host $server
    gsettings set org.gnome.system.proxy.http port $port
    gsettings set org.gnome.system.proxy.ftp host $server
    gsettings set org.gnome.system.proxy.ftp port $port
    gsettings set org.gnome.system.proxy.https host $server
    gsettings set org.gnome.system.proxy.https port $port
    gsettings set org.gnome.system.proxy.socks host $server
    gsettings set org.gnome.system.proxy.socks port $port
    gsettings set org.gnome.system.proxy ignore-hosts "['localhost', 
'127.0.0.0/8', '10.0.0.0/8', '*.localdomain.com' ]"
}

function proxy_off(){
    unset http_proxy
    unset https_proxy
    unset ftp_proxy
    unset rsync_proxy
    unset HTTP_PROXY
    unset HTTPS_PROXY
    unset RSYNC_PROXY
    gsettings reset org.gnome.system.proxy mode
    gsettings reset org.gnome.system.proxy.http host
    gsettings reset org.gnome.system.proxy.http port    
    gsettings reset org.gnome.system.proxy.ftp host
    gsettings reset org.gnome.system.proxy.ftp port
    gsettings reset org.gnome.system.proxy.https host 
    gsettings reset org.gnome.system.proxy.https port
    gsettings reset org.gnome.system.proxy.socks host
    gsettings reset org.gnome.system.proxy.socks port
    gsettings reset org.gnome.system.proxy ignore-hosts

    echo -e "Proxy environment variable removed."
}

#New tab same directory fix
. /etc/profile.d/vte.sh
