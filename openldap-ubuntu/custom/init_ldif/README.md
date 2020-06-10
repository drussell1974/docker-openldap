Container run ldif files
========================

Place init.ldif file in the /custom/init directory. This will be run when the container is run.

The docker-entrypoint.sh script will run ldap these files (defaulting init/init.ldif)

variables
---------
e.g.

*required*

LDAP_BASE_DN = dc=example,dc=org
LDAP_ADMIN_USER = cn=admin
LDAP_ADMIN_PASSWORD = YourP455w0rd


custom init directory and file
------------------------------

Place the directory and file in the custom folder in the build location on the host.

*optional*

e.g.

LDAP_INIT_DIR = my-init-scripts/
LDAP_INIT_FILE = my-data.ldif



