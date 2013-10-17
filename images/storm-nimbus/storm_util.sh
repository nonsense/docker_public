#!/bin/bash

#. /scripts/setenv.sh

binpath="/storm-0.8.3-wip3/bin/storm"

install_dir="/init"
log_dir="/logs/riqtopologies"
RETVAL=0

kill() {
	echo `date`
	$binpath kill $1 -w 30 >/dev/null 2>&1 &
}

swapjar() {
	kill $1
	keepgoing=1
	count=1
	while [[ $count -lt 5 && $keepgoing -gt 0 ]]; do
		echo "jar try $count"
		command="$binpath jar $install_dir/$2 $3 $4 2>&1"
		echo $command
		$command
		keepgoing=$?
		count=$(($count+1))
		if [ $keepgoing -gt 0 ]; then
			echo "topology still there, sleeping..."
			# 35 because kill timeout defaults to 30s and we only want to sleep once
			sleep 35
		fi
	done
	echo `date`
	echo \"$result\"
	if [ $count -eq 5 ]; then
		echo "failed to add jar"
		exit 1
	fi
}

case "$1" in
	swapjar)
		swapjar "$2" "$3" "$4" "$5"
		;;
	kill)
		kill "$2"
		;;
	*)
		echo $"Usage: $0 {swapjar|kill}"
		RETVAL=1
esac
