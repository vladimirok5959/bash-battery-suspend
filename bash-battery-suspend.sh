#!/bin/bash

# MIT License
# https://github.com/vladimirok5959/bash-battery-suspend

# Settings
BAT_SUSPEND_MSG_PERC="20"
BAT_SUSPEND_ACT_PERC="15"

# Consts
CONST_PID_FILE="/tmp/batt.suspend.pid"

batt_check_util() {
	util_name="$1"
	check=`\
		whereis $util_name | \
		awk '{ print $2 }' \
	`
	if [ "$check" = "" ]; then
		echo "Error: '$util_name' is not found..."
		exit
	fi
}

batt_get_percentage() {
	percentage=`\
		upower \
		-i /org/freedesktop/UPower/devices/battery_BAT0 | \
		grep "percentage:" | \
		awk '{ print $2 }' | \
		sed 's/[^0-9]$//g' \
	`
	echo "${percentage}"
}

batt_warning_msg() {
	notify-send \
	--urgency=critical \
	"Battery is critically low" \
	"OS will be suspended on ${BAT_SUSPEND_ACT_PERC}%"
}

batt_suspend() {
	systemctl suspend -i
}

batt_pid_get() {
	if [ -f "${CONST_PID_FILE}" ]; then
		cat ${CONST_PID_FILE}
	else
		echo "0"
	fi
}

batt_pid_set() {
	echo "$1" > ${CONST_PID_FILE}
}

batt_pid_del() {
	if [ -f "${CONST_PID_FILE}" ]; then
		rm ${CONST_PID_FILE}
	fi
}

batt_loop() {
	BAT_DO_MSG="0"
	BAT_DO_ACT="0"

	while [ 1 ]
	do
		current=$(batt_get_percentage)
		if (( BAT_DO_MSG == 0 )); then
			if (( current <= BAT_SUSPEND_MSG_PERC )); then
				BAT_DO_MSG="1"
				batt_warning_msg
			fi
		fi
		if (( current <= BAT_SUSPEND_ACT_PERC )); then
			BAT_DO_ACT="1"
			break
		fi
		sleep 2
	done

	batt_pid_del

	if (( BAT_DO_ACT == 1 )); then
		batt_suspend
	fi
}

start() {
	pid=$(batt_pid_get)
	if (( pid == 0 )); then
		(
			batt_loop
			exit 0
		)&
		batt_pid_set "$!"
		status
	else
		echo "Already!"
		status
	fi
}

stop() {
	pid=$(batt_pid_get)
	if (( pid == 0 )); then
		echo "Script is not runned"
	else
		kill -9 ${pid}
		batt_pid_del
		echo "Stopped!"
	fi
}

status() {
	pid=$(batt_pid_get)
	if (( pid == 0 )); then
		echo "Status: is not runned"
	else
		echo "Status: runned"
		echo "Alert perc: ${BAT_SUSPEND_MSG_PERC}%"
		echo "Suspend perc: ${BAT_SUSPEND_ACT_PERC}%"
	fi
}

usage() {
	echo "$0 (start|stop|status)"
	status
}

batt_check_util "grep"
batt_check_util "upower"
batt_check_util "systemctl"
batt_check_util "notify-send"

case $1 in
	"start")
		start
		;;
	"stop")
		stop
		;;
	"status")
		status
		;;
	*)
		usage
		;;
esac
exit
