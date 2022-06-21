#!/bin/bash

cd /root/ && rails s -b 0.0.0.0 & >> /var/log/rails.output.log
sleep 3
date
