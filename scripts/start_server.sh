#!/bin/bash

cd /home/ec2-user/ruby_app/  && rails s -b 0.0.0.0 & >> /tmp/rails.output.log
sleep 3
date
