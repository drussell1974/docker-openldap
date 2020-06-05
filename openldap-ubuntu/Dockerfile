FROM ubuntu
MAINTAINER dave@daverussell.co.uk

# TODO: Read ENV ADMIN_PASSWORD, UNSAFE_SELFWRITE_ACL, PURGE_DATABASE, DOMAIN, PPOLICY_SCHEMA_NEEDS_UPDATE, INVALID_CONFIG, MOVE_OLD_DATABASE, BACK_END, ORGANISATION_NAME, BACKUP_DIR, NO_CONFIGURATION, DUMP_DATABASE, 
ENV DOMAIN=ldap_JTC

RUN apt-get update && apt-get install -y apt-utils
# install slapd from config file (may need to be used dpkg-reconfigure in sh file)
# create a working directory
RUN mkdir /usr/src/app 
WORKDIR /usr/src/app
# insert slapd config settings for a silent install using debconf, then install slapd in noninteractive mode
COPY slapd-debconf.dat .
RUN debconf-set-selections slapd-debconf.dat && cat slapd-debconf.dat | debconf-set-selections
RUN export DEBIAN_FRONTEND=noninteractive && apt-get install -y slapd ldap-utils
RUN debconf-show slapd

# create volumes for ldap cofiguration  data and ssh
#ADD conf /container/service/slapd/assets/config/bootstrap
#ADD data /container/service/slapd/assets/certs
#ADD ssh /container/environment/01-custom

# run when container starts
ENTRYPOINT service slapd start && bash


EXPOSE 389 636
