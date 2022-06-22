#!/usr/bin/bash

sudo chown -R ec2-user:ec2-user /home/ec2-user/ruby_app/
#sudo chmod 666 /home/ec2-user/ruby_app/Gemfile.lock
gem install puma -v 5.6.4
cd /home/ec2-user/ruby_app/ && bundle install
