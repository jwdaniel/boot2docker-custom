# set a custom network
B2D_IPADDR=172.28.42.1

# install bridge-utils                        
[ -f /var/lib/boot2docker/bridge-utils.tcz ] || curl -Lso /var/lib/boot2docker/bridge-utils.tcz ftp://ftp.nl.netbsd.org/vol/2/metalab/d
su docker sh -c 'tce-load -i /var/lib/boot2docker/bridge-utils.tcz'

# stops all container and docker itself
docker stop -t 1 $(docker ps -q)
/etc/init.d/docker stop

# creates bridge0
ifconfig bridge0 >/dev/null 2>&1 && (ifconfig bridge0 down && brctl delbr bridge0) 
brctl addbr bridge0
ifconfig bridge0 $B2D_IPADDR netmask 255.255.255.0

# update profile
cat > /var/lib/boot2docker/profile <<"EOF"
EXTRA_ARGS="-b=bridge0"
DOCKER_HOST="-H unix:// -H tcp://0.0.0.0:2375"
EOF

# start docker
/etc/init.d/docker start

