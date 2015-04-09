FROM boot2docker/boot2docker
MAINTAINER Jian-Wei Wang "jwdaniel(at)gmail.com"

# disable dhcp
RUN sed -i 's/^\(\s\+append .*\)$/\1 nodhcp/' /tmp/iso/boot/isolinux/isolinux.cfg

# configure networking
RUN echo										>>$ROOTFS/opt/bootscript.sh && \
	echo "# assign static ip addr"				>>$ROOTFS/opt/bootscript.sh && \
	echo "ip link set eth0 up"					>>$ROOTFS/opt/bootscript.sh && \
	echo "ip addr add 192.168.8.200 dev eth0"	>>$ROOTFS/opt/bootscript.sh && \
	echo "ip route add 192.168.8.0/24 dev eth0"	>>$ROOTFS/opt/bootscript.sh && \
	echo "ip route add default via 192.168.8.1"	>>$ROOTFS/opt/bootscript.sh && \
	echo "nameserver 8.8.8.8"					>>$ROOTFS/etc/resolv.conf

RUN /make_iso.sh
CMD ["cat", "boot2docker.iso"]

