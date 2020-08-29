#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias please='sudo'
alias th123c='LANG=zh_CN.UTF-8 prime-run wine ~/Touhou/th123c/th123_beta.exe'

# alias ls='ls --color=auto'
alias ls='exa'

alias ll='ls -l'
alias la='ls -la'
alias lh='ls -lh'

alias start="sudo systemctl start"
alias stop="sudo systemctl stop"
alias restart="sudo systemctl restart"
alias status="systemctl status"

alias .="source"
alias cp="cp -i --reflink=auto"
alias :q="exit"
alias :w="sync"
alias :x="sync && exit"
alias :wq="sync && exit"

alias linuxqq="rm -rf $HOME/.config/tencent-qq/1318000868/ && qq &"
alias adb3="adb disconnect && adb connect 192.168.0.102:5555 && scrcpy"
alias adbp="adb disconnect && adb connect 192.168.0.101:5555 && scrcpy"

# pacman aliases and functions
function Syu(){
    sudo pacsync && sudo powerpill -Suw $@ && sudo pacman -Su $@ && sync
    sudo pacman -Fy && sync
    pacman -Qtdq | ifne sudo pacman -Rcs -
    sync
}

alias Rcs="sudo pacman -Rcs"
alias Ss="pacman -Ss"
alias Si="pacman -Si"
alias Sl="pacman -Sl"
alias Sg="pacman -Sg"
alias Qs="pacman -Qs"
alias Qi="pacman -Qi"
alias Qo="pacman -Qo"
alias Ql="pacman -Ql"
alias Qlp="pacman -Qlp"
alias Qm="pacman -Qm"
alias Qn="pacman -Qn"
alias U="sudo pacman -U"
alias F="pacman -F"
alias Fo="pacman -F"
alias Fs="pacman -F"
alias Fl="pacman -Fl"
alias Fy="sudo pacman -Fy"
alias Sy="sudo pacman -Sy"
alias Ssa="pikaur -Ssa"
alias Sas="pikaur -Ssa"
alias Sia="pikaur -Sai"
alias Sai="pikaur -Sai"

function Ga() {
    [ -z "$1" ] && echo "usage: Ga <aur package name>: get AUR package PKGBUILD" && return 1
    TMPDIR=$(mktemp -d)
    git clone aur@aur.archlinux.org:"$1".git "$TMPDIR"
    rm -rf "$TMPDIR"/.git
    mkdir -p "$1"
    cp -r -i "$TMPDIR"/* "$1"/
    rm -rf "$TMPDIR"
}

function G() {
    git clone https://git.archlinux.org/svntogit/$1.git/ -b packages/$3 --single-branch $3
    mv "$3"/trunk/* "$3"
    rm -rf "$3"/{repos,trunk,.git}
}

function Gw() {
    [ -z "$1" ] && echo "usage: Gw <package name> [directory (default to pwd)]: get package file *.pkg.tar.xz from pacman cache" && return 1
    sudo pacman -Sw "$1" && cp /var/cache/pacman/pkg/$1*.pkg.tar.xz ${2:-.}
}

function Ge() {
    [ -z "$@" ] && echo "usage: $0 <core/extra package name>: get core/extra package PKGBUILD" && return 1
    for i in $@; do
    	G packages core/extra $i
    done
}

function Gc() {
    [ -z "$@" ] && echo "usage: $0 <community package name>: get community package PKGBUILD" && return 1
    for i in $@; do
    	G community community $i
    done
}

alias rankpacman='sed "s/^#//" /etc/pacman.d/mirrorlist.pacnew | rankmirrors -n 10 - | sudo tee /etc/pacman.d/mirrorlist'
alias urldecode='python2 -c "import sys, urllib as ul; print ul.unquote_plus(sys.argv[1])"'
alias urlencode='python2 -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1])"'
imgvim(){
    curl -F "name=@$1" https://img.vim-cn.com/
}

simg(){
    scrot $@ -e 'curl -F \"name=@$f\" https://img.vim-cn.com/'
}

ttm(){
    curl -F "file=@$1" https://ttm.sh/
}

alias pvim="curl -F 'vimcn=<-' https://cfp.vim-cn.com/"


alias clipboard="xclip -selection clipboard"
alias Ci="clipboard -i"
alias Co="clipboard -o"
alias Copng="Co -target image/png"

fs() {
  curl -s -F "c=@${1:--}" "https://fars.ee/?u=1" | tee /dev/tty | perl -p -e 'chomp if eof' | Ci
}

# custom
alias setproxy="export all_proxy=socks5://127.0.0.1:1088"


function _git_prompt() {
    local git_status="`git status -unormal 2>&1`"
    if ! [[ "$git_status" =~ Not\ a\ git\ repo ]]; then
        if [[ "$git_status" =~ nothing\ to\ commit ]]; then
            local ansi=42
        elif [[ "$git_status" =~ nothing\ added\ to\ commit\ but\ untracked\ files\ present ]]; then
            local ansi=43
        else
            local ansi=45
        fi
        if [[ "$git_status" =~ On\ branch\ ([^[:space:]]+) ]]; then
            branch=${BASH_REMATCH[1]}
            test "$branch" != master || branch=' '
        else
            # Detached HEAD.  (branch=HEAD is a faster alternative.)
            branch="(`git describe --all --contains --abbrev=4 HEAD 2> /dev/null ||
                echo HEAD`)"
        fi
        echo -n '\[\e[0;37;'"$ansi"';1m\]'"$branch"'\[\e[0m\] '
    fi
}
function _prompt_command() {
    PS1="`_git_prompt`"'\[\e[1;32m\]\u\[\e[m\]\[\e[0;32m\]@\h\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\] '
}
PROMPT_COMMAND=_prompt_command

EDITOR="vim"
export EDITOR
GOPATH="$HOME/Project/go"
export GOPATH
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$HOME/.local/bin

function ranger-cd {
    tempfile="$(mktemp)"
    /usr/bin/ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
        cd -- "$(cat "$tempfile")"
    fi
    rm -f -- "$tempfile"
}
