local GPG_ENV=${HOME}/.gnupg/gpg-agent.env

function _gpg_agent_main () {
    if [[ ! -f "${GPG_ENV}" ]]; then
        # start and source the script
        eval "$(/usr/bin/env gpg-agent \
                --quiet \
                --daemon \
                --enable-ssh-support \
                --use-standard-socket \
                --write-env-file "${GPG_ENV}" \
                2> /dev/null)"
        chmod 600 "${GPG_ENV}"
    fi

    source "${GPG_ENV}" 2> /dev/null

    export GPG_AGENT_INFO
    export SSH_AUTH_SOCK
    export SSH_AGENT_PID

    GPG_TTY=$(tty)
    export GPG_TTY
}

function _gpg_agent_reset () {
    pkill -TERM gpg-agent
    pkill -TERM ssh-agent
    rm -f "${GPG_ENV}"
    _gpg_agent_main
}

_gpg_agent_main
