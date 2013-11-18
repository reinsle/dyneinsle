#
# Regular cron jobs for the dyneinsle package
#
@reboot         root	[ -x /usr/bin/update-dyneinsle.sh ] && /usr/bin/update-dyneinsle.sh
*/5   * * * *	root	[ -x /usr/bin/update-dyneinsle.sh ] && /usr/bin/update-dyneinsle.sh
