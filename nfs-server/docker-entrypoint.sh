#!/bin/sh

# create directories 

echo "docker-entrypoint.sh: creating directories for public (${NFS_PUBLIC_CONT}) and home (${NFS_HOME_CONT}}..."
mkdir -p  $NFS_PUBLIC_CONT && \
mkdir -p  $NFS_HOME_CONT && \
chown -R nobody:nogroup $NFS_PUBLIC_CONT && \
chmod 777 $NFS_PUBLIC_CONT && \
chown -R nobody:nogroup $NFS_HOME_CONT && \
chmod 777 $NFS_HOME_CONT

# Give permission to subnet - e.g. /mnt/nfs_share/ 192.168.1.0/24(rw,sync,no_subtree_check)
# requires NFS_IPADDR_ALLOWED environment variable

echo "\ndocker-entrypoint.sh: allowing ${NFS_IPADDR_ALLOWED} to ${NFS_PUBLIC_CONT} in /etc/exports ..."
echo "${NFS_PUBLIC_CONT} ${NFS_IPADDR_ALLOWED}(rw,sync,no_subtree_check)" >> /etc/exports


echo "\ndocker-entrypoint.sh: allowing ${NFS_IPADDR_ALLOWED} to ${NFS_HOME_CONT} in /etc/exports ..."
echo "${NFS_HOME_CONT} ${NFS_IPADDR_ALLOWED}(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports

## nfs4 only ##

# nfs4 only: disable then readd both existing config options in /etc/default/nfs-common
echo "\ndisable nfs4 in /etc/default/nfs-common and /etc/default/nfs-kernel-server"

sed -i "s/NEED_STATD=/#NEED_STATD=/" "s/NEED_IDMAPD=/#NEED_IDMAPD=/" /etc/default/nfs-common
echo "NEED_STATD=\"no\"" >> /etc/default/nfs-common
echo "NEED_IDMAPD=\"yes\"" >> /etc/default/nfs-common

# disable then readd exiting config options in etc/nfs-kernel-server

sed -i "s/RPCNFSDOPS=/#RPCNFSDOPTS=/" "s/RPCMOUNTOPTS=/#RPCMOUNTOPTS=/" /etc/default/nfs-kernel-server
echo "RPCNFSDOPTS=\"-N 2 -N 3\"" >> etc/default/nfs-kernel-server
echo "RPCMOUNTDOPTS=\"--manage-gids -N 2 -N 3\"" >> etc/default/nfs-kernel-server

# nfs4 only: disable rpcbind

sudo systemctl mask rpcbind.service
sudo systemctl mask rpcbind.socket


# refresh nfs service

echo "\ndocker-entrypoint.sh: applying exportfs and restarting portmap and nfs-kernel-server..."
exportfs -ra && \
service nfs-kernel-server reload

# show content

echo "\ndocker-entrypoint.sh: showing contents of ${NFS_HOME_CONT} ..."
ls -l ${NFS_HOME_CONT}

echo "\ndocker-entrypoint.sh: showing contents of ${NFS_PUBLIC_CONT} ..."
ls -l ${NFS_PUBLIC_CONT}

# prevent docker from exiting
echo "\ndocker-entrypoint.sh: keep alive!"
tail -f /dev/null


