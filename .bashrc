#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias kys='sudo shutdown -h now'


export TERM=xterm-256color
# Use colored prompts
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

export LESS='-R'

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/gustave/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/gustave/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/gustave/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/gustave/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

alias rys="sudo shutdown -r now"

#function to execute personal scripts from home/personalScripts as binaries
personal-script() {
    local script_name="$1"
    shift  # Remove first argument, leaving the rest as parameters

    local script_dir="$HOME/personalScripts"

    # Try to find the script with any extension
    local script_path=""

    # First try exact match (no extension)
    if [ -f "$script_dir/$script_name" ] && [ -x "$script_dir/$script_name" ]; then
        script_path="$script_dir/$script_name"
    else
        # Try with common extensions
        for ext in .py .sh .rb .js .pl ""; do
            if [ -f "$script_dir/$script_name$ext" ] && [ -x "$script_dir/$script_name$ext" ]; then
                script_path="$script_dir/$script_name$ext"
                break
            fi
        done
    fi

    if [ -n "$script_path" ]; then
        "$script_path" "$@"
    else
        echo "Error: Script '$script_name' not found in $script_dir" >&2
        return 1
    fi
}

