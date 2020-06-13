#!/bin/sh

_ldapadd_autofs_ldif() {
	
	# 1. Add autofs-ldap.ldif to ldap directory

	echo "docker-entrypoing.sh: adding autofs-ldap.ldif to ldap directory ${LDAP_BASE_DN}\n"
	
	ldapadd -Y EXTERNAL -H ldapi:/// -f autofs-ldap.ldif 
}

_ldapadd_init_ldif() {

	# 1. check if LDAP_INIT true

	# 2. check init directory and file variables have set
	
	# 3. check init directory and init file exists

	# 4. check the base dn, admin user and admin password has been set
	
	# 5. if LDAP_INIT_BOOTSTRAP true then replace dc=example,dc=net with LDAP_BASE_DN
	
	# 6. replace IP Address of NFS Server in automountInformation

	# 7. add ldap directory - command should be format e.g. ldapadd -w <PASSWORD> -D "cn=admin,dc=example,dc=net" -f init/init.ldif

	echo "docker-entrypoint.sh: LDAP_INIT=${LDAP_INIT} LDAP_INIT_BOOTSTRAP=${LDAP_INIT_BOOTSTRAP}\n"

	if [ ${LDAP_INIT:-false} = true ] ; then
		echo "docker-entrypoint.sh: checking ${LDAP_INIT_DIR:=init_ldif}/${LDAP_INIT_FILE:=init.ldif} for ${LDAP_BASE_DN}\n"
		if test -f ${LDAP_INIT_DIR}/${LDAP_INIT_FILE}; then
			echo "docker-entrypoint.sh: adding ldif to ldap directory ${LDAP_ADMIN_USER},${LDAP_BASE_DN}\n"
			if [ ${LDAP_BASE_DN:-$LDAP_BASE_DN} -a ${LDAP_ADMIN_USER:-$LDAP_ADMIN_USER} -a ${LDAP_ADMIN_PASSWORD:-$LDAP_ADMIN_PASSWORD} ]; then 

				# replace base dn if bootstrapped
				
				if [ ${LDAP_INIT_BOOTSTRAP:-false} = true ]; then
					sed -i "s/dc=example,cd=net/${LDAP_BASE_DN}/" ${LDAP_INIT_DIR}/${LDAP_INIT_FILE}
				fi

				# replace automount ip address

				sed -i "s/automountInformation: 0.0.0.0/automountInformation: ${LDAP_NFS_SERVER_IPADDR:-1.1.1.1}/" ${LDAP_INIT_DIR}/${LDAP_INIT_FILE}

				# add the record...
			
				ldapadd -w "${LDAP_ADMIN_PASSWORD}" -D "${LDAP_ADMIN_USER},${LDAP_BASE_DN}" -f $LDAP_INIT_DIR/$LDAP_INIT_FILE
		
			else
				echo "docker-entrypoint.sh: Cannot execute command 'ldapadd -w ***** -D ${LDAP_ADMIN_USER},${LDAP_BASE_DN} -f ${LDAP_INIT_DIR}/${LDAP_INIT_FILE}', as LDAP_BASE_DN, LDAP_ADMIN_USER or LDAP_ADMIN_PASSWORD not set.\n"
			fi
		else
			echo "docker-entrypoint.sh: directory (${LDAP_INIT_DIR}/${LDAP_INIT_FILE}) for ${LDAP_BASE_DN} does not exist\n"
		fi
	fi
}

_main() {

	service slapd start

	_ldapadd_autofs_ldif

	_ldapadd_init_ldif 

	echo "keep alive\n"
	tail -f /dev/null
}

_main
