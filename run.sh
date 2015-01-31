#!/usr/bin/env bash

set -e

ADAGIOS_HOST=${ADAGIOS_HOST:-localhost}
ADAGIOS_USER=${ADAGIOS_USER:-admin}
ADAGIOS_PASS=${ADAGIOS_PASS:-P@ssw0rd}
GIT_REPO=${GIT_REPO:-false}

# Set password if htpasswd file does not exist yet
if [[ ! -f /etc/nagios/passwd ]]
then
    htpasswd -c -b /etc/nagios/passwd "$ADAGIOS_USER" "$ADAGIOS_PASS"
fi

# Init git repo at /etc/nagios
if [[ "$GIT_REPO" = "true" && ! -d /etc/nagios/.git ]]
then
    cd /etc/nagios
    echo "passwd" > .gitignore
    git init
    git add .
    git commit -m "Initial commit"
    chown -R nagios /etc/nagios/.git
fi

# Create necessary logfile structure
touch /var/log/nagios/nagios.log
for dir in /var/log/nagios/{archives,spool/checkresults}
do
    if [[ ! -d "$dir" ]]
    then
        mkdir -p "$dir"
    fi
done
chown -R nagios /var/log/nagios

# Execute custom init scripts
for script in $(ls -1 /opt/*.sh 2> /dev/null)
do
    [[ -x "$script" ]] && "$script"
done

exec /usr/bin/supervisord -n -c /etc/supervisord.conf
