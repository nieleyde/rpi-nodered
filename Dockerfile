# DOCKER-VERSION 1.0.0
FROM yyolk/rpi-archlinuxarm

# install required packages
RUN pacman -Syu --noconfirm
RUN pacman-db-upgrade
RUN pacman -Sy unzip wget --noconfirm

# install RPi.GPIO
RUN pacman -Sy python2 python2-pip gcc make sudo --noconfirm
ENV PYTHON /bin/python2
RUN pip2 install RPi.GPIO
RUN touch /usr/share/doc/python-rpi.gpio


# install nodejs
RUN pacman -U http://rollback.archlinuxarm.org/2015/02/15/armv6h/community/nodejs-0.10.36-3-armv6h.pkg.tar.xz --noconfirm

# install rpi tools 
RUN pacman -Sy raspberrypi-firmware-tools --noconfirm

# Hack for python to resolve to python2 
# https://wiki.archlinux.org/index.php/python#Python_2
WORKDIR /root/bin
RUN ln -s /bin/python2.7 ~/bin/python
RUN ln -s /bin/python2.7-config ~/bin/python-config
env PATH ~/bin:$PATH

# install nodered - from source
WORKDIR /src/
RUN wget https://github.com/node-red/node-red/archive/0.10.6.zip
RUN unzip 0.10.6.zip
WORKDIR /src/node-red-0.10.6
RUN npm install --production

# install nodered - npm install  - DIDN'T WORK ON 2/27 - npm cb() error
##WORKDIR /usr/lib/node_modules/node-red
#ENV USER root
#RUN npm install node-red

# install nodered nodes
RUN npm i node-red-contrib-googlechart
RUN npm i node-red-node-web-nodes

# fix "nrpgio python command not running" error
COPY ./source /src/node-red-0.10.6/nodes/core/hardware
RUN chmod 777 /src/node-red-0.10.6/nodes/core/hardware/nrgpio

# run application
EXPOSE 1880
#CMD ["/bin/bash"]
ENTRYPOINT ["node","--max-old-space-size=128","red.js","-v"]

