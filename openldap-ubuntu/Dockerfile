FROM ubuntu
MAINTAINER Dave Russell, dave@daverussell.co.uk

# INSTALL OpenLDAP FROM DEBCONF FILE

# apt-utils is required for the debconf

RUN apt-get update && apt-get install -y apt-utils autofs autofs-ldap

# create a working directory
WORKDIR /usr/openldap/install

# installing slapd from config file, set selections, then install slapd in noninteractive mode
ADD slapd-debconf.sh .

# Added autoconf to the LDAP directory
ADD autofs-ldap.ldif .

# create volumes for ldap cofiguration, ldap data and certificates ssh
# copy sldapd-debconf.dat file and custom folder to install folder
ADD custom .

# Add volume for initialised ldif file and persisted data
## Use command 'docker volume craate <VOLUME_NAME>' to create named volume and -v parameter when running container 'docker run -v <VOLUME_NAME>:<CONTAINER_PATH> openldap-server'
### - place ldif files to be executed when running container ###
### - location for data files to be persisted when running container ###
### do not change any data in the volume after this line ###
VOLUME ["/usr/openldap/install/init/ldif", "/usr/openldap/install/data"]

# start service when container starts
COPY docker-entrypoint.sh .
ENTRYPOINT ["/usr/openldap/install/docker-entrypoint.sh"]

# Expose LDAP ports 389 non-secure port or 636 secure port for tls
# FOR DOCUMENTATION PURPOSE ONLY you use the '-p 389:389 -p 636:636' in 
# the command line or - ports: -389:389 -636:636 in docker-compose.yml file
EXPOSE 389 636
