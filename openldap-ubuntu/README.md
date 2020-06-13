OPENLDAP SERVER
================
A basic LDAPServer installation with Docker. I've created it just for fun.

Building the image
------------------
------------------
1. Create a build folder and download the build files to your docker host server

> mkdir -p my_ldap_server

- Download Dockerfile
> wget https://raw.githubusercontent.com/drussell1974/docker-openldap/master/openldap-ubuntu/Dockerfile

- Download docker-compose.yml (Docker Compose only)
> wget https://raw.githubusercontent.com/drussell1974/docker-openldap/master/openldap-ubuntu/docker-compose.yml

- Download docker-entrypoint.sh
> wget https://raw.githubusercontent.com/drussell1974/docker-openldap/master/openldap-ubuntu/docker-entrypoint.sh

- Download slapd-debconf.sh
> wget https://raw.githubusercontent.com/drussell1974/docker-openldap/master/openldap-ubuntu/slapd-debconf.sh

2. Ensure the sh files are executable

> chmod 755 docker-entrypoint.sh

> chmod 755 slapd-debconf.sh

Build configuration
-------------------
Change the ENV values in the Dockerfile 

> vim Dockerfile

```
MAINTAINER Jane Doe, jdoe@example.net

ENV LDAP_ORGANIZATION_NAME="Example Net"
ENV LDAP_DOMAIN="example.net"
<<<<<<< HEAD
ENV LDAP_ADMIN_PASSWORD=<PASSWORD>
=======
ENV LDAP_ADMIN_PASSWORD="Password1."
>>>>>>> development
```
Build configuration
-------------------

*Option 1: Using Docker CLI*

1. From this directory containing the Dockerfile build the image 
 
> docker build -t openldap-server:latest .

*Option 2: Using Docker Compose*

1. From this directory containing the Dockerfile build the image 

> docker-compose build

*The output from the build should include the ENV values set in the Dockerfile, except the password (other environment variable can be used to set the other values - not yet supported).*

```
setting up slapd (2.4.49+dfsg-2ubuntu1.2) ...
  Creating new user openldap... done.
  Creating initial configuration... done.
  Creating LDAP directory... done.
invoke-rc.d: could not determine current runlevel
invoke-rc.d: policy-rc.d denied execution of start.
Processing triggers for libc-bin (2.31-0ubuntu9) ...
  slapd/internal/adminpw: (password omitted)
* slapd/password1: (password omitted)
* slapd/internal/generated_adminpw: (password omitted)
* slapd/internal/sadminpw: (password omitted)
* slapd/password2: (password omitted)
* slapd/domain: example.net
* slapd/backend: MDB 
  slapd/unsafe_selfwrite_acl:
* slapd/ppolicy_schema_needs_update: abort installation
* slapd/invalid_config: true
* slapd/purge_database: false
* shared/organization: Dave Russell Home
* slapd/no_configuration: false
* slapd/dump_database_destdir: /var/backups/slapd-backup
  slapd/upgrade_slapcat_failure:
  slapd/password_mismatch:
* slapd/move_old_database: true 
* slapd/dump_database: when needed

```
Run the container
-----------------
-----------------

*Option 1: Using Docker CLI*

1. Get the image from hub.docker.com/drussell1974

> docker pull drussell1974/openldap

```
 docker run -itd -p 389:389 --hostname ldap.example.net
   -e LDAP_DOMAIN=example.net
   -e LDAP_BASE_DN=dc=example,dc=net
   -e LDAP_ORGANIZATION_NAME=Example Net
   -e LDAP_ADMIN_USER=cn=admin
   -e LDAP_ADMIN_PASSWORD=<PASSWORD>
   drussell1974/openldap-server:latest
```

*Option 2: Using Docker Compose*

1. Create or edit the .env 

```
LDAP_DOMAIN=example.net
LDAP_BASE_DN=dc=example,dc=net
LDAP_ORGANIZATION_NAME=Example Net
LDAP_ADMIN_USER=cn=admin
LDAP_ADMIN_PASSWORD=<PASSWORD>
```

> docker-compose up

The output with init.ldif

```
drussell1974@jtc1:~/docker/openldap-server$ sudo docker-compose up
Recreating openldap-server_ldapserver_1 ... done
Attaching to openldap-server_ldapserver_1
ldapserver_1  |  * Starting OpenLDAP slapd
ldapserver_1  |    ...done.
ldapserver_1  | docker-entrypoint.sh: checking init_ldif/init.ldif for dc=example,dc=net
ldapserver_1  | docker-entrypoint.sh: adding ldif to ldap directory cn=admin,dc=example,dc=net
ldapserver_1  | adding new entry "ou=employees,dc=example,dc=net"
ldapserver_1  | 
ldapserver_1  | adding new entry "cn=netadmins,ou=employees,dc=example,dc=net"
ldapserver_1  | 
ldapserver_1  | adding new entry "cn=users,ou=employees,dc=example,dc=net"
ldapserver_1  | 
ldapserver_1  | adding new entry "uid=jdoe,ou=employees,dc=example,dc=net
ldapserver_1  | 
ldapserver_1  | adding new entry "uid=anna,ou=employees,dc=example,dc=net"
ldapserver_1  | 
ldapserver_1  | keep alive

```

The output without init.ldif

```
ldapserver_1  |  * Starting OpenLDAP slapd
ldapserver_1  |    ...done.
ldapserver_1  | docker-entrypoint.sh: checking init_ldif/init.ldif for dc=example,dc=net
ldapserver_1  | keep alive
```


Test OpenLDAP is running (where dc is your domain)
--------------------------------------------------

> ldapsearch -x -b dc=example,dc=net

```
# extended LDIF
#
# LDAPv3
# base <dc=example,dc=net> with scope subtree
# filter: (objectclass=*)
# requesting: ALL
#

# example
dn: dc=example,dc=net
objectClass: top
objectClass: dcObject
objectClass: organization
o: Example Net
dc: example

# admin, example.net
dn: cn=admin,dc=example,dc=net
objectClass: simpleSecurityObject
objectClass: organizationalRole
cn: admin
description: LDAP administrator

# search result
search: 2
result: 0 Success

# numResponses: 3
# numEntries: 2
```


Automating the build on hub.docker.com/drussell1974/openldap through github.com/drussell1974/docker-openldap
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
1. Merge and push the build to the master branch on github.com/drussell/docker-openldap

- Develop the changes on development branch. Once you've checked in your changes to development.

> git checkout master

> git merge development

> git push
