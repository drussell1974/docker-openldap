#!/bin/bash i 

## Replace version ##

# regex match e.g. v2020.06.19.0319-alpha

match=v[0-9][0-9][0-9][0-9]\.[0-9][0-9]\.[0-9][0-9]\.[0-9][0-9][0-9][0-9]

timestamp=$(date +"v%Y.%m.%d.%H%M%S")

sed "s/$match/$timestamp/" docker-compose.yml

#sed -i "s/$match/date +$timestamp/" docker-compose.yml

# Add automatically changed files to the commit

git add openldap-server.tar.gz docker-compose.yml docker-compose.yml.example .env.example

# Create Tag

git tag $timestamp

echo -e "git tag $timestamp created! Remember to git push origin v$timestamp"
