#!/bin/bash

export RAILS_DB_PASS=Akki@1332
cd /home/ec2-user/ruby_app/  && rails s -b 0.0.0.0 & >> /tmp/rails.output.log
sleep 3
date
