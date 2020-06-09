#!/bin/sh

_ldapadd_init_ldif() {

	# 1. check init directory and file variables have set
	
	# 2. check init directory and init file exists

	# 3. check the base dn, admin user and admin password has been set
	
	# 4. command should be format e.g. ldapadd -w <PASSWORD> -D "cn=admin,dc=daverussell,dc=co,dc=uk" -f custom/init/1_add_group.ldif

	if test -f ${LDAP_INIT_DIR:="init"}/${LDAP_INIT_FILE:="init.ldif"}; then
		if [ ${LDAP_BASE_DN:-$LDAP_BASE_DN} -a ${LDAP_ADMIN_USER:-$LDAP_ADMIN_USER} -a ${LDAP_ADMIN_PASSWORD:-$LDAP_ADMIN_PASSWORD} ]; then 
			
			echo "docker-entrypoint.sh: adding ldif to ldap directory ${LDAP_ADMIN_USER},${LDAP_BASE_DN}"

			# add the record...

			ldapadd -w "${LDAP_ADMIN_PASSWORD}" -D "${LDAP_ADMIN_USER},${LDAP_BASE_DN}" -f $LDAP_INIT_DIR/$LDAP_INIT_FILE
		
		else
			echo "docker-entrypoint.sh: Cannot 'ldapadd ... ${LDAP_INIT_DIR}/${LDAP_INIT_FILE}', as LDAP_BASE_DN, LDAP_ADMIN_USER or LDAP_ADMIN_PASSWORD not set."
		fi
	fi
}

_main() {

	service slapd start

	_ldapadd_init_ldif 
	
	echo "keep alive"

	tail -f /dev/null
}

_main
