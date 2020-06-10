Directories
-----------
*cert* - place any tcl certificates and keys required for secure access to ther 'ldap directory'
*data* - contains ldap data - can be mapped to a volume to persist the 'ldap directory' on the docker host
*exmamples* - useful files such as ldif for adding or modifying data in the 'ldap directory'
*init* - place init.ldif file in the /custom/init directory. This will be run when the container is run.
