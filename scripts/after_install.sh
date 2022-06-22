#!/usr/bin/bash

sudo chmod o+w Gemfile.lock
cd /home/ec2-user/ && bundle install
