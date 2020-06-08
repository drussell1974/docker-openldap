FROM ubuntu
MAINTAINER Dave Russell, dave@daverussell.co.uk

# TODO: Read ENV LDAP_ADMIN_PASSWORD, LDAP_UNSAFE_SELFWRITE_ACL, LDAP_PURGE_DATABASE, LDAP_DOMAIN, LDAP_PPOLICY_SCHEMA_NEEDS_UPDATE, LDAP_INVALID_CONFIG, LDAP_MOVE_OLD_DATABASE, LDAP_BACK_END, LDAP_ORGANISATION_NAME, LDAP_BACKUP_DIR, LDAP_NO_CONFIGURATION, LDAP_DUMP_DATABASE, 
ENV LDAP_DOMAIN=jtc


# INSTALL OpenLDAP FROM DEBCONF FILE

# apt-utils is required for the debconf
RUN apt-get update && apt-get install -y apt-utils

# create a working directory
WORKDIR /usr/openldap/install

# get setting for installing slapd from config file, set selections, then install slapd in noninteractive mode
COPY slapd-debconf.dat .
RUN debconf-set-selections slapd-debconf.dat && cat slapd-debconf.dat | debconf-set-selections
RUN export DEBIAN_FRONTEND=noninteractive && apt-get install -y slapd ldap-utils
# show installation parameter output for debugging
RUN debconf-show slapd

# create volumes for ldap cofiguration, ldap data and certificates ssh
# copy sldapd-debconf.dat file and custom folder to install folder
ADD slapd-debconf.dat .
ADD custom .

# Add volume for initialised ldif file and persisted data
## Use command 'docker volume craate <VOLUME_NAME>' to create named volume and -v parameter when running container 'docker run -v <VOLUME_NAME>:<CONTAINER_PATH> openldap-server'
### - place ldif files to be executed when running container ###
### - location for data files to be persisted when running container ###
### do not change any data in the volume after this line ###
VOLUME ["/usr/openldap/install/init", "/usr/openldap/install/data"]

# start service when container starts
ENTRYPOINT service slapd start && bash

# Expose LDAP ports 389 non-secure port or 636 secure port for tls
# FOR DOCUMENTATION PURPOSE ONLY you use the '-p 389:389 -p 636:636' in 
# the command line or - ports: -389:389 -636:636 in docker-compose.yml file
EXPOSE 389 636
