#
# ~/.bashrc
#

export PATH=$PATH:`go env GOPATH`/bin:~/.local/bin:`yarn global bin`
export LIBVA_DRIVER_NAME=i965
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias please='sudo'
alias th123c='LANG=zh_CN.UTF-8 prime-run wine ~/Touhou/th123c/th123_beta.exe'

#alias ls='ls --color=auto'
alias ls='exa -gb'

alias lsd='exa -gb --icons'
alias ll='lsd -l'
alias la='lsd -laa'
alias lh='lsd -lh'
alias lah='lsd -lah'
alias grep='grep --color'
alias k="kde-open5"
alias x="xdg-open"

alias start="sudo systemctl start"
alias stop="sudo systemctl stop"
alias restart="sudo systemctl restart"
alias status="systemctl status"
alias reload="sudo systemctl reload"

alias .="source"
alias cp="cp -i --reflink=auto --sparse=auto"
alias :q="exit"
alias :w="sync"
alias :x="sync && exit"
alias :wq="sync && exit"

# pacman aliases and functions
function Syu(){
    sudo pacsync pacman -Sy && sudo pacman -Su $@  && sync
    pacman -Qtdq | ifne sudo pacman -Rcs - && sync
    sudo pacsync pacman -Fy && sync
    pacdiff -o
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
alias Fx="pacman -Fx"
alias Fl="pacman -Fl"
alias Fy="sudo pacman -Fy"
alias Sy="sudo pacman -Sy"
alias Ssa="paru -Ssa"
alias Sas="paru -Ssa"
alias Sia="paru -Sia"
alias Sai="paru -Sia"

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
    sudo pacman -Sw "$1" && cp /var/cache/pacman/pkg/$1*.pkg.tar.* ${2:-.}
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

alias limit-run='/usr/bin/time systemd-run --user --pty --same-dir --wait --collect --slice=limit-run.slice '
alias limit-cpu='/usr/bin/time systemd-run --user --pty --same-dir --wait --collect --slice=limit-cpu.slice '
alias limit-mem='/usr/bin/time systemd-run --user --pty --same-dir --wait --collect --slice=limit-mem.slice '

alias urldecode='python3 -c "import sys, urllib.parse as up; print(up.unquote(sys.argv[1]))"'
alias urlencode='python3 -c "import sys, urllib.parse as up; print(up.quote(sys.argv[1]))"'
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

Ct(){
    t=$(mktemp /tmp/furigana-XXXX)
    python -m furigana.furigana $(Co) | sed 's@<ruby><rb>@ :ruby:`@g;s@</rb><rt>@|@g;s@</rt></ruby>@` @g' | sponge $t
    cat $t | tee /dev/tty | perl -pe 'chomp if eof' | Ci
}

fs() {
  curl -s -F "c=@${1:--}" "https://fars.ee/?u=1" | tee /dev/tty | perl -p -e 'chomp if eof' | Ci
}

alias setproxy="export all_proxy=socks5://127.0.0.1:1088"

dsf(){
    # depends on diff-so-fancy
    git diff --color=always $@ | diff-so-fancy | less
}

man() {
	env \
		LESS_TERMCAP_mb=$(printf "\e[1;37m") \
		LESS_TERMCAP_md=$(printf "\e[1;37m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[1;47;30m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[0;36m") \
			man "$@"
}

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

# S_COLORS for sysstat
export S_COLORS=auto

function ranger-cd {
    tempfile="$(mktemp)"
    /usr/bin/ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
        cd -- "$(cat "$tempfile")"
    fi
    rm -f -- "$tempfile"
}
