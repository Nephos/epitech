# .bashrc                                                                                                                                                                                                                                     

# Source global definitions                                                                                                                                                                                                                   
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:                                                                                                                                                             
# export SYSTEMD_PAGER=                                                                                                                                                                                                                       

# User specific aliases and functions                                                                                                                                                                                                         

alias ll='ls -l'
alias l='ls -l'
alias la='ls -la'
alias j='jobs'
alias emacs='emacs -nw'
alias ne='emacs'
alias clean='find . -name "*~" -exec rm "{}" ";"'
alias blih='~/bin/blih.py'
alias gitshow='blih -u jaryst_p repository list'
alias dropbox='~/.dropbox-dist/dropboxd'
