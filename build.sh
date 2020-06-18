#!/bin/bash i 

YELLOW='\133[0;31m'
NC='\033[0m'

currv=$(git describe --tags)

# get input for new version

echo "Current version is: $currv\nPlease enter the new version # (format 1.0.0):\n"

read newv

echo "Please enter a build suffix (e.g. beta or rc)"
#TODO: Enter 1. alpha  2. beta  3. rc 4
read rtype


#if [ rtype ]then;
#	
#fi

echo Creating tag v$newv-$rtype

#TODO: Continue? Loop if N
#read start_over


match=v[0-9]\.[0-9]\.[0-9].*

sed "s/$match/$newv-$rtype/" docker-compose.yml

#TODO: Confirm preview

sed -i "s/$match/$newv-$rtype/" docker-compose.yml

git add openldap-server.tar.gz docker-compose.yml docker-compose.yml.example .env.example

git tag v$newv-$rtype

echo -e "${YELLOW}git tag v$newv-$rtype${NC} created! Remember to ${YELLOW}git push origin v$newv-$type${NC}"
