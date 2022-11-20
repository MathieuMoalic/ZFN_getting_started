export EDITOR=vim
export VISUAL=vim

export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.cache

export LESSHISTFILE=$XDG_CACHE_HOME/less/history
export PATH=$HOME/grant_398/scratch/bin:$PATH
export SLURM_TIME_FORMAT="%H:%M:%S"
export TERM=xterm-color
export PATH="/home/users/mathieum/.local/share/conda/bin:$PATH"

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias rl='source ~/.bash_profile'
alias freespace='lfs quota -h -p 398 ~/grant_398/project_data && lfs quota -h -p 3980000 ~/grant_398/scratch'
alias sq='sacct -X --format=JobName%22,State,Elapsed,Start%10,End%10,Nodelist%8 -S $(date -d "3 days ago" +%D-%R)'
alias sqa='sacct -X --format=JobID,JobName%22,State,Elapsed,Submit%10,Start%10,End%10,Nodelist%8,Timelimit -S $(date -d "3 days ago" +%D-%R)'
alias tq='squeue -p tesla --format="%.26j %.26u %.8T %.12M %.12l %R"'
alias rm=' rm -vdrf'
alias cp='cp -r'
alias mkdir=' mkdir -p'
alias ls="exa -a --across --icons -s age"
alias ll='ls -hlg'
alias lt='ll --tree'
alias l='ls '

fsrun () {
    srun -n 1 -c 1 --mem=4G -t 01:00:00 -p fast --pty /bin/bash
}
copytest () {
    echo "Testing drive speed in $1"
    dd if=/dev/urandom of=$1/test bs=8k count=10k; \rm $1/test
}
speedtest () {
    copytest $HOME
    copytest /tmp/lustre_shared/groups/grant_398
    copytest /mnt/storage_2/project_data/grant_398
    copytest /mnt/storage_2/scratch/grant_398
    copytest /mnt/storage_3/archive/grant_398
}
q () {
    calc_modes=0
    for arg in "$@"; do 
        if [ $arg == "-m" ];then
            calc_modes=1
            continue
        fi
        mx3_path=$PWD/$arg
        zarr_path="${mx3_path/.mx3/.zarr}"
        log_path=$zarr_path/slurm.logs
        calc_log_path=$zarr_path/slurm_calc.logs
        batch_name="$(basename "$(dirname $mx3_path)")"
        job_name="${arg/.mx3/}"
        mkdir -p $zarr_path
        JobID=$(sbatch --job-name="$job_name" --output="$log_path" $HOME/sbatch/amumax.sh $mx3_path | cut -f 4 -d' ')
        sbatch -d afterany:$JobID --job-name="calc_$job_name" --output=$calc_log_path $HOME/sbatch/amumax_post.sh $zarr_path $batch_name $calc_modes > /dev/null
        echo " - Submitted job for ${job_name}.mx3"
    done
}
qo () {
    for arg in "$@"; do 
        mx3_path=$PWD/$arg
        zarr_path="${mx3_path/.mx3/.zarr}"
        log_path=$zarr_path/slurm.logs
        job_name="${arg/.mx3/}"
        mkdir -p $zarr_path
        sbatch --job-name="$job_name" --output="$log_path" $HOME/sbatch/amumax2.sh $mx3_path
        echo " - Submitted job for ${job_name}.mx3"
    done
}

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac






