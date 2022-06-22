#!/usr/bin/bash

#sudo chmod 666 /home/ec2-user/Gemfile.lock
gem install puma -v 5.6.4
cd /home/ec2-user/ && bundle install
