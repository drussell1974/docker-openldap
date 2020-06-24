Container run ldif files
========================

Place init.ldif file in the /custom/init/ldif directory. This will be run when the container is run.

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

LDAP_INIT - whether to run the INIT files (default false) 
LDAP_INIT_BOOTSTRAP - changes dc=example,dc=net in ldif files to uses the distinguished name LDAP_BASE_DN variable (default false)
LDAP_INIT_LDIF_PATH - the path to the custom folder is the base (default init/init.ldif)


With LDAP_INIT and LDAP_INIT_BOOTSTRAP set to true the script will attempt to replace example.net.

e.g.
```
LDAP_INIT = true
LDAP_INIT_BOOTSTRAP = true
```

You can replace existing init.ldif or a custom path can be set in the LDAP_INIT_LDIF_PATH environmental varilable 

```
LDAP_INIT_LDIF_PATH = my-ldifs/my-data.ldif
```


