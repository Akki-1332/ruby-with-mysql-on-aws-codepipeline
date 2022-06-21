#!/usr/bin/bash

cat /root/tmp/pids/server.pid
if [ $? == 0 ]
then
	echo -e "\n server is running, Going to stop it \n"
	kill `cat /root/tmp/pids/server.pid`
	sleep 3
	echo -e "Server STOPPED \n"
else
	echo "Need to start server"
fi

