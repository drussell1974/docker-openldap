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
		
  echo "docker-entrypoint.sh: LDAP_INIT=${LDAP_INIT} LDAP_INIT_BOOTSTRAP=${LDAP_INIT_BOOTSTRAP}\n"

        if [ ${LDAP_INIT:-false} = true ] ; then

                echo "docker-entrypoint.sh: initialising ldap directory ${LDAP_BASE_DN} from files ${LDAP_INIT_LDIF_PATH:=init/ldif/init.ldif}\n"

                for file_path in ${LDAP_INIT_LDIF_PATH}; do

                        echo "docker-entrypoint.sh: checking ${file_path} exists\n"

                        if test -f ${file_path}; then

                                if [ ${LDAP_INIT_BOOTSTRAP:-false} = true ]; then 
                                        # replace base dn if bootstrapped
                                        echo "docker-entrypoint.sh: bootstrapping\n"
                                        sed -i "s/dc=example,dc=net/${LDAP_BASE_DN}/" ${file_path}
                                fi

                                # replace automountInformation
                                echo "docker-entrypoint.sh: apply nfs automount ip address with ${LDAP_NFS_SERVER_IPADDR} \n"                           
                                sed -i "s/0.0.0.0/${LDAP_NFS_SERVER_IPADDR}/" ${LDAP_INIT_LDIF_PATH}

                                # add data to ldap directory
                                echo "docker-entrypoint.sh: adding file to ldap directory\n"

                                ldapadd -w "${LDAP_ADMIN_PASSWORD}" -D "${LDAP_ADMIN_USER},${LDAP_BASE_DN}" -f $file_path
                        else
                                echo "docker-entrypoint.sh: directory (${file_path} for ${LDAP_BASE_DN} does not exist\n"
                        fi
                done
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
