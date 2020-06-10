OPENLDAP SERVER
================
A basic LDAPServer installation with Docker. I've created it just for fun.

Building the image
------------------
------------------
1. Prebuild configuration

> vim Dockerfile

```
MAINTAINER Jane Doe, jdoe@example.net

ENV LDAP_ORGANIZATION_NAME="Example Net"
ENV LDAP_DOMAIN="example.net"
ENV LDAP_ADMIN_PASSWORD="Password1."
```
A. Using Docker CLI
-------------------

1. From this directory containing the Dockerfile build the image 
 
> docker build -t openldap-server:latest .

B. Using Docker Compose
-----------------------

1. From this directory containing the Dockerfile build the image 

> docker-compose build

Automating the build on hub.docker.com/drussell1974/openldap through github.com/drussell1974/docker-openldap
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
1. Merge and push the build to the master branch on github.com/drussell/docker-openldap

- Develop the changes on development branch. Once you've checked in your changes to development.

> git checkout master

> git merge development

> git push

Run the container
-----------------
-----------------
A. Using Docker CLI
-------------------
1. Logon to your server

2. Get the image from hub.docker.com/drussell1974

> docker pull drussell1974/openldap

> docker run -itd -p 389:389 --hostname ldap.example.net drussell1974/openldap-server:latest

B. Using Docker Compose
-----------------------

1. Create or edit the .env 

```
LDAP_DOMAIN=example.net
LDAP_BASE_DN=dc=example,dc=net
LDAP_ORGANIZATION_NAME=Example Net
LDAP_ADMIN_USER=cn=admin
LDAP_ADMIN_PASSWORD=<PASSWORD>
```

> docker-compose build


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
