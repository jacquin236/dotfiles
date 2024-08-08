# Sources:
# - https://zsh.sourceforge.io/Doc/Release/Options.html#History
# - https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/history.zsh

## History file configuration
[ -z "$HISTFILE" ] && HISTFILE="${__zsh_user_data_dir}/zsh_history"
[ -d "${HISTFILE:h}" ] || mkdir -p "${HISTFILE:h}"
[ "$HISTSIZE" -lt 50000 ] && HISTSIZE=50000
[ "$SAVEHIST" -lt 10000 ] && SAVEHIST=10000

## History command configuration
setopt bang_hist                # Treat The '!' Character Specially During Expansion.
setopt inc_append_history       # Write To The History File Immediately, Not When The Shell Exits.
setopt share_history            # Share History Between All Sessions.
setopt hist_expire_dups_first   # Expire A Duplicate Event First When Trimming History.
setopt hist_ignore_dups         # Do Not Record An Event That Was Just Recorded Again.
setopt hist_ignore_all_dups     # Delete An Old Recorded Event If A New Event Is A Duplicate.
setopt hist_find_no_dups        # Do Not Display A Previously Found Event.
setopt hist_ignore_space        # Do Not Record An Event Starting With A Space.
setopt hist_save_no_dups        # Do Not Write A Duplicate Event To The History File.
setopt hist_verify              # Do Not Execute Immediately Upon History Expansion.
setopt extended_history         # Show Timestamp In History.

## History alias
alias hist='fc -li'
alias hist-stat="history 0 | awk '{print \$2}' | sort | uniq -c | sort -n -r | head"
