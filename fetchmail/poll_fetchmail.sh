#!/bin/sh

do_poll_loop() {
	while true
	do
		sleep 20
		fetchmail --pidfile /etc/fetchmail/fetchmail.pid -f /etc/fetchmail/.fetchmailrc
	done
}

if ! whoami &> /dev/null; then
  if [ -w /etc/passwd ]; then
    echo "${USER:-default}:x:$(id -u):0:${USER:-default} user:${HOME}:/sbin/nologin" >> /etc/passwd
  fi
fi
sed -e"s/PUT_USER_HERE/\"$USER\"/" -e"s/PUT_PASS_HERE/\"$PASS\"/" /etc/fetchmail/fetchmailrc > /etc/fetchmail/.fetchmailrc && chmod 600 /etc/fetchmail/.fetchmailrc

touch /etc/fetchmail/fetchmail.log
fetchmail --pidfile /etc/fetchmail/fetchmail.pid -f /etc/fetchmail/.fetchmailrc --daemon 10



