#!/bin/sh

## Replace version ##

# regex match e.g. v2020.06.19.031959-alpha

match=v[0-9][0-9][0-9][0-9]\.[0-9][0-9]\.[0-9][0-9]\.[0-9][0-9][0-9][0-9][0-9][0-9]
 
newversion=$(date +"v%Y.%m.%d.%H%M%S")

sed -i "s/$match/$newversion/" docker-compose.yml

# Add automatically changed files and commit

git add openldap-server.tar.gz docker-compose.yml docker-compose.yml.example .env.example
git commit -m "build.sh: add build files for $newversion"

# Create Tag

git tag $newversion

echo "#############################################################
#   YOU MUST GIT PUSH THE REPOSITORY BEFORE PUSHING THE TAG #
# > git push                                                #
# > git push origin $newversion                      #
#                                                           # 
#############################################################"
