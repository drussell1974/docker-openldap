OPEN LDAP SERVER
================

Building the image
------------------

1. Enter the LDAP Server information into the slapd-debconf.dat

> vim slapd-defconf.data

```
slapd slapd/password1 password <password>
slapd slapd/internal/adminpw password <password>
slapd slapd/internal/generated_adminpw password <password>
slapd slapd/password2 password <password>
slapd slapd/unsafe_selfwrite_acl note
slapd slapd/purge_database boolean false
slapd slapd/domain string daverussell.co.uk
slapd slapd/ppolicy_schema_needs_update select abort installation
slapd slapd/invalid_config boolean true
slapd slapd/move_old_database boolean true
slapd slapd/backend select MDB
slapd shared/organization string Dave Russell Web
slapd slapd/dump_database_destdir string /var/backups/slapd-daverussell
slapd slapd/no_configuration boolean false
slapd slapd/dump_database select when needed

```

2. Save and close


2. From this directory containing the Dockerfile build the image 
 
> docker build -t openldap-server:latest .

Automating the build on hub.docker.com/drussell1974/openldap through github.com/drussell1974/docker-openldap
------------------------------------------------------------------------------------------------------------

3. Merge and push the build to the master branch on github.com/drussell/docker-openldap

- Develop the changes on development branch. Once you've checked in your changes to development.

> git checkout master

> git merge development

> git push

Running the container open the server
-------------------------------------
1. Logon to your server

2. Get the image from hub.docker.com/drussell1974

> docker pull drussell1974/openldap

> sudo docker run -d -p 389:389 --hostname ldap.daverusell.co.uk drussell1974/openldap-server:latest

3. Test OpenLDAP is running (where dc is your domain)

> ldapsearch -x -b dc=daverussell,dc=co,dc=uk

```
# extended LDIF
#
# LDAPv3
# base <dc=daverussell,dc=co,dc=uk> with scope subtree
# filter: (objectclass=*)
# requesting: ALL
#

# daverussell.co.uk
dn: dc=daverussell,dc=co,dc=uk
objectClass: top
objectClass: dcObject
objectClass: organization
o: Dave Russell Ltd
dc: daverussell

# admin, daverussell.co.uk
dn: cn=admin,dc=daverussell,dc=co,dc=uk
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
