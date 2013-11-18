#
# Regular cron jobs for the dyneinsle package
#
0 4	* * *	root	[ -x /usr/bin/dyneinsle_maintenance ] && /usr/bin/dyneinsle_maintenance
