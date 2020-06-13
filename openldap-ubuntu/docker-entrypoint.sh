#!/bin/sh

# TODO: Read ENV LDAP_ADMIN_PASSWORD, LDAP_UNSAFE_SELFWRITE_ACL, LDAP_PURGE_DATABASE, LDAP_DOMAIN, LDAP_PPOLICY_SCHEMA_NEEDS_UPDATE, LDAP_INVALID_CONFIG, LDAP_MOVE_OLD_DATABASE, LDAP_BACK_END, LDAP_ORGANISATION_NAME, LDAP_BACKUP_DIR, LDAP_NO_CONFIGURATION, LDAP_DUMP_DATABASE, 


#----------------------------------------------------------------#
#| install ldap server in silent mode use environment varialbes |#
#----------------------------------------------------------------#
_install_slapd() {
	echo "docker-entrypoing.sh: installing slapd - noninteractive"

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

	echo "docker-entrypoing.sh: debconf-set-selection file"
	debconf-set-selections slapd-debconf.dat

	#echo "file | debconf-set-selection"
	#cat slapd-debconf.dat | debconf-set-selections

	export DEBIAN_FRONTEND=noninteractive && apt-get install -y slapd ldap-utils

	# show installation parameter output for debugging
	debconf-show slapd

	# start service
	service slapd start
}

#---------------------------------#
#| add the autofs-ldap.ldif file |#
#---------------------------------#
_ldapadd_autofs_ldif() {
	
	# 1. Add autofs-ldap.ldif to ldap directory

	echo "docker-entrypoing.sh: adding autofs-ldap.ldif to ldap directory ${LDAP_BASE_DN}\n"
	
	ldapadd -Y EXTERNAL -H ldapi:/// -f autofs-ldap.ldif 
}

#---------------------------------------------------------#
#| run the init.ldif file to populate the ldap directory |#
#---------------------------------------------------------#
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
		echo "docker-entrypoint.sh: checking ${LDAP_INIT_LDIF_PATH:=init/ldif/init.ldif} for ${LDAP_ADMIN_USER},${LDAP_BASE_DN}\n"
		if test -f ${LDAP_INIT_LDIF_PATH}; then
			if [ ${LDAP_BASE_DN:-$LDAP_BASE_DN} -a ${LDAP_ADMIN_USER:-$LDAP_ADMIN_USER} -a ${LDAP_ADMIN_PASSWORD:-$LDAP_ADMIN_PASSWORD} ]; then 

				# replace base dn if bootstrapped
				
				if [ ${LDAP_INIT_BOOTSTRAP:-false} = true ]; then
					echo "docker-entrypoint.sh: apply bootstrap ${LDAP_INIT_LDIF_PATH} with ${LDAP_BASE_DN}\n"
					sed -i "s/dc=example,dc=net/${LDAP_BASE_DN}/" ${LDAP_INIT_LDIF_PATH}
				fi

				echo "docker-entrypoint.sh: apply nfs automount ip address with ${LDAP_NFS_SERVER_IPADDR} \n"
					
				sed -i "s/automountInformation: 0.0.0.0/automountInformation:${LDAP_NFS_SERVER_IPADDR}/" ${LDAP_INIT_LDIF_PATH}

				# add the record...
			
				echo "docker-entrypoint.sh: adding ${LDAP_INIT_LDIF_PATH} to ldap directory ${LDAP_ADMIN_USER},${LDAP_BASE_DN}\n"
				ldapadd -w "${LDAP_ADMIN_PASSWORD}" -D "${LDAP_ADMIN_USER},${LDAP_BASE_DN}" -f ${LDAP_INIT_LDIF_PATH}
		
			else
				echo "docker-entrypoint.sh: Cannot execute command 'ldapadd -w ***** -D ${LDAP_ADMIN_USER},${LDAP_BASE_DN} -f ${LDAP_INIT_LDIF_PATH}', as LDAP_BASE_DN, LDAP_ADMIN_USER or LDAP_ADMIN_PASSWORD not set.\n"
			fi
		else
			echo "docker-entrypoint.sh: directory (${LDAP_INIT_LDIF_PATH} for ${LDAP_BASE_DN} does not exist\n"
		fi
	fi
}

#--------------------------------------------------#
#| THE MAIN FUNCTION EXECUTE WHEN THE FILE IS RUN |#
#--------------------------------------------------#
_main() {
 	
	#sh -c /usr/openldap/install/slapd-debconf.sh
	_install_slapd

	_ldapadd_autofs_ldif

	_ldapadd_init_ldif 

	echo "keep alive\n"
	tail -f /dev/null
}

_main
