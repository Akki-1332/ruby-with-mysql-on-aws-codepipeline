#!/usr/bin/bash

sudo yum update -y
sudo yum install gcc git -y 
sudo amazon-linux-extras install ruby3.0 -y
sudo yum install ruby-devel -y
sudo gem install rails

