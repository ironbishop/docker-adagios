# pschmitt/adagios

## Quick start

```bash
docker run -d --name adagios -p 80:80 pschmitt/adagios
```

Adagios will be available at http://localhost/adagios and nagios at http://localhost/nagios

Log in as "admin", password: "P@ssw0rd".

## Custom init

You can put shell scripts in the `/opt` directory. They will be executed once
the container is spawned. An example can be found at `custom-init-sample.sh`.
This one installs the speedtest-cli module from
http://exchange.nagios.org/directory/Plugins/Network-Connections,-Stats-and-Bandwidth/check_speedtest-2Dcli/details

**NOTE**: These scripts must end with the ".sh" extension and need to be executable.

**NOTE**: Bear in mind that these scripts will be executed EVERY TIME you start
your container.

## Variables

- ADAGIOS_HOST: Hostname (Default: localhost)
- ADAGIOS_USER: Username for accessing the adagios web interface (Default: admin)
- ADAGIOS_PASS: Password for accessing the adagios web interface (Default: P@ssw0rd)
- GIT_REPO: Whether /etc/nagios should be kept in a git repo. (Default: false)

## Volumes

- /etc/nagios
- /var/log/nagios

## Complete Example

```bash
docker run -d -h nagios -p 80:80 \
  -e ADAGIOS_USER=pschmitt \
  -e ADAGIOS_PASS=nagios \
  -e GIT_REPO=true \
  -v ~/dev/docker/adagios/data/nagios:/etc/nagios \
  -v ~/dev/docker/adagios/data/log:/var/log/nagios \
  -v ~/dev/docker/adagios/data/opt:/opt \
  pschmitt/adagios
```

## systemd service file

```
[Unit]
Description=Adagios/Nagios container
After=docker.service
Requires=docker.service

[Service]
TimeoutStartSec=0
ExecStartPre=-/usr/bin/docker kill adagios
ExecStartPre=-/usr/bin/docker rm adagios
ExecStartPre=/usr/bin/docker pull pschmitt/adagios
ExecStart=/usr/bin/docker run -h nagios --name adagios -p 80:80 \
  -e ADAGIOS_USER=pschmitt \
  -e ADAGIOS_PASS=nagios \
  -e GIT_REPO=true \
  -v /srv/nagios/config:/etc/nagios \
  -v /srv/nagios/log:/var/log/nagios \
  -v /srv/nagios/opt:/opt \
  pschmitt/adagios

[Install]
WantedBy=multi-user.target
```
