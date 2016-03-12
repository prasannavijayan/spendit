#!/usr/bin/env bash

apt-get update
echo "Successfully updated the system"
apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev
echo "Installed all the required components for the ruby and rails."
echo "-----------------------------------------------"
echo "| Starting the RVM installation --------------|"
echo "-----------------------------------------------"
curl -L https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm install 2.2.3
echo "Installing the Ruby version 2.2.3"
rvm use 2.2.3 --default
ruby -v
echo "Test your version by using ruby -v"
echo "gem: --no-ri --no-rdoc" > ~/.gemrc
gem install bundler

echo "Installing the ruby bundler"

echo "You need git :)"
echo "Please configure in the server accordingly."

echo "Installing the postgres, if you wish mysql please check the documentation for that online how to install mysql in ubuntu"
sudo sh -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main' > /etc/apt/sources.list.d/pgdg.list"
wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install postgresql-common
sudo apt-get install postgresql-9.3 libpq-dev

echo "Create and set new user for postgres or use default postgres"
echo "------------------------------Viola-----------------------------"
echo "Seems everything is installed, now go to the rails app"
