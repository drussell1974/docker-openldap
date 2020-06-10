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
ENV LDAP_ADMIN_PASSWORD=<PASSWORD>
```
Build configuration
-------------------

*Option 1: Using Docker CLI*

1. From this directory containing the Dockerfile build the image 
 
> docker build -t openldap-server:latest .

*Option 2: Using Docker Compose*

1. From this directory containing the Dockerfile build the image 

> docker-compose build

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


Automating the build on hub.docker.com/drussell1974/openldap through github.com/drussell1974/docker-openldap
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
1. Merge and push the build to the master branch on github.com/drussell/docker-openldap

- Develop the changes on development branch. Once you've checked in your changes to development.

> git checkout master

> git merge development

> git push
