#!/bin/bash

export RAILS_DB_PASS=Akki@1332
cmd="cd /home/ec2-user/ruby_app/  && rails s -b 0.0.0.0"
eval "${cmd}" &>/dev/null & disown;
