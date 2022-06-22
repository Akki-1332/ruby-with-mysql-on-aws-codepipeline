#!/bin/bash

export RAILS_DB_PASS=Akki@1332
cd /home/ec2-user/ruby_app/  && rails s -e production -d
sleep 5
date
