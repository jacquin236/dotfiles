# Sources:
# - https://zsh.sourceforge.io/Doc/Release/Options.html#History
# - https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/history.zsh

autoload -Uz add-zsh-hook
add-zsh-hook zshaddhistory max_history_len
function max_history_len() {
    if (($#1 > 240)) {
        return 2
    }
    return 0
}

## History file configuration
[ -z "$HISTFILE" ] && HISTFILE="${__zsh_user_data_dir}/zsh_history"
[ -d "${HISTFILE:h}" ] || mkdir -p "${HISTFILE:h}"
[ "$HISTSIZE" -lt 50000 ] && HISTSIZE=50000
[ "$SAVEHIST" -lt 10000 ] && SAVEHIST=10000

## History command configuration
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_find_no_dups      # do not display a previously found event
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_reduce_blanks     # Remove extra blanks from commands added to the history list
setopt hist_save_no_dups      # do not write a duplicate event to the history file
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data
setopt inc_append_history     # write to the history file immediately, not 'till when the shell exits

## History alias
alias hist='fc -li'
alias hist-stat="history 0 | awk '{print \$2}' | sort | uniq -c | sort -n -r | head"
