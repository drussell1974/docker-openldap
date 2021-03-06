#!/bin/sh
# TODO: Read ENV LDAP_ADMIN_PASSWORD, LDAP_UNSAFE_SELFWRITE_ACL, LDAP_PURGE_DATABASE, LDAP_DOMAIN, LDAP_PPOLICY_SCHEMA_NEEDS_UPDATE, LDAP_INVALID_CONFIG, LDAP_MOVE_OLD_DATABASE, LDAP_BACK_END, LDAP_ORGANIZATION_NAME, LDAP_BACKUP_DIR, LDAP_NO_CONFIGURATION, LDAP_DUMP_DATABASE, 

echo "slapd slapd/password1 password ${LDAP_ADMIN_PASSWORD}
 slapd slapd/internal/sadminpw password ${LDAP_ADMIN_PASSWORD}
 slapd slapd/internal/generated_adminpw password ${LDAP_ADMIN_PASSWORD}
 slapd slapd/password2 password ${LDAP_ADMIN_PASSWORD}
 slapd slapd/unsafe_selfwrite_acl ${LDAP_UNSAFE_SELFWRITE_ACL:-notes}
 slapd slapd/purge_database boolean ${LDAP_PURGE_DATABASE:-false}
 slapd slapd/domain string ${LDAP_DOMAIN}
 slapd slapd/ppolicy_schema_needs_update select ${LDAP_PPOLICY_SCHEMA_NEEDS_UPDATE:=abort installation}
 slapd slapd/invalid_config boolean ${LDAP_INVALID_CONFIG:-true}
 slapd slapd/move_old_database boolean ${LDAP_MOVE_OLD_DATABASE:-true} 
 slapd slapd/backend select ${LDAP_BACKEND_SELECT:-MDB} 
 slapd shared/organization string ${LDAP_ORGANIZATION_NAME}
 slapd slapd/dump_database_destdir string /var/backups/slapd-${LDAP_BACKUP_DIR:-backup}
 slapd slapd/no_configuration boolean ${LDAP_NO_CONFIGURATION:-false}
 slapd slapd/dump_database select ${LDAP_DUMP_DATABASE=when needed}" > slapd-debconf.dat #| defconf-set-selections

#echo "debconf-set-selection file"
debconf-set-selections slapd-debconf.dat

#echo "file | debconf-set-selection"
#cat slapd-debconf.dat | debconf-set-selections

export DEBIAN_FRONTEND=noninteractive && apt-get install -y slapd ldap-utils

# show installation parameter output for debugging
debconf-show slapd

