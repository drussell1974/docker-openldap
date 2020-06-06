FROM debian:jessie

MAINTAINER Dave Russell, dave@daverussell.co.uk

# INSTALL OpenLDAP FROM DEBCONF FILE

# install ldap client tools
RUN apt-get update && apt-get install -y apt-utils

# create a working directory
WORKDIR /usr/libnss/install

# get setting for installing slapd from config file, set selections, then install slapd in noninteractive mode
COPY libnss-debconf.dat .
#COPY pam_mkhomedir.sh .
#RUN debconf-set-selections libnss-debconf.data && cat 
RUN cat libnss-debconf.dat | debconf-set-selections
RUN export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get install -y libnss-ldap libpam-ldap ldap-utils nscd
RUN debconf-show libnss-ldap && debconf-show libpan-ldap

# Use ldap as a data source by appending ldap to the lines compat
RUN sed -i "s/compat/compact ldap/" /etc/nsswitch.conf

# append the ldap.conf file for replication
# echo "uri ldap://ldap1.example.com  ldap://ldap2.example.com" >> /etc/ldap.conf

# Replace the use_authtok with try_Step 4 - Testingfirst_pass
# before: 	password	[success=1 user_unknown=ignore default=die]	pam_ldap.so use_authtok try_first_pass
# after 	password	[success=1 user_unknown=ignore default=die]	pam_ldap.so try_Step 4 -Testingfirst_pass
RUN sed -i "s/use_authtok try_first_pass/try_Step 4 - Testingfirst_pass/" /etc/pam.d/common-password

# Append common-session file so user home directory is created automatically
RUN echo "session required pam_mkhomedir.so skel=/etc/skel umask=077" >> /etc/pam.d/common-session

