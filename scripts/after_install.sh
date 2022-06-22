#!/usr/bin/bash

sudo chmod 666 /home/ec2-user/Gemfile.lock
cd /home/ec2-user/ && bundle install
