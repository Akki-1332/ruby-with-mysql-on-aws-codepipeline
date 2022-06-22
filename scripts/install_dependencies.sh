#!/usr/bin/bash

#sudo yum update -y
#sudo yum install gcc git -y 
#sudo amazon-linux-extras install ruby3.0 -y
#sudo yum install ruby-devel -y
#sudo gem install rails

rbenv install 3.1.0
rbenv global 3.1.0
echo "gem: --no-document" > ~/.gemrc
gem install rails
rbenv rehash

sudo yum install mysql-devel -y
