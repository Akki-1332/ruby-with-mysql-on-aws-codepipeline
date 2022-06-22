#!/usr/bin/bash

cat /home/ec2-user/ruby_app/tmp/pids/server.pid
if [ $? == 0 ]
then
	echo -e "\n server is running, Going to stop it \n"
	kill `cat /home/ec2-user/ruby_app/tmp/pids/server.pid`
	sleep 3
	echo -e "Server STOPPED \n"
else
	echo "Need to start server"
fi

