#!/bin/bash

sudo touch /home/r-gcaitlyn/cron_md5
sudo chmod 777 /home/r-gcaitlyn/cron_md5
a="$(md5sum '/etc/crontab' | awk '{print $1}')"
b="$(cat '/home/r-gcaitlyn/cron_md5')"

if [ "$a" != "$b" ] ; then
	md5sum /etc/crontab | awk '{print $1}' > /home/r-gcaitlyn/cron_md5
	echo "Warning" | mail -s "Cronfile md5 diff warning" root@debian.lan
fi
