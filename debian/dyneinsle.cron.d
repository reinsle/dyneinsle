#
# Regular cron jobs for the dyneinsle package
#
0/15  * * * *	root	[ -x /usr/bin/update-dyneinsle.sh ] && /usr/bin/update-dyneinsle.sh
