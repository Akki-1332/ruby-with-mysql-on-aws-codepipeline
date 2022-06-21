#!/usr/bin/bash

yum update -y
yum install gcc git -y 
amazon-linux-extras install ruby3.0 -y
yum install ruby-devel -y
gem install rails

