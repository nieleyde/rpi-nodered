# DOCKER-VERSION 1.0.0
FROM resin/rpi-raspbian

# install required packages, in one command
RUN apt-get update && \
    apt-get install -y  python-dev

ENV PYTHON /usr/bin/python2

# install nodejs 0.10.36 for rpi 
#RUN apt-get install -y wget && \
#    wget http://node-arm.herokuapp.com/node_0.10.36_armhf.deb && \
#    dpkg -i node_0.10.36_armhf.deb && \
#    rm node_0.10.36_armhf.deb && \
#    apt-get autoremove -y wget


# install nodejs 0.11.10 for rpi2
RUN apt-get install -y wget && \
    wget http://nodejs.org/dist/v0.11.10/node-v0.11.10-linux-arm-pi.tar.gz && \
    gunzip node-v0.11.10-linux-arm-pi.tar.gz && \
    tar xvf node-v0.11.10-linux-arm-pi.tar && \
    apt-get autoremove -y wget

env PATH /node-v0.11.10-linux-arm-pi/bin:$PATH

# install RPI.GPIO python libs
RUN apt-get install -y python-pip mercurial && \
    pip install hg+http://hg.code.sf.net/p/raspberry-gpio-python/code#egg=RPi.GPIO && \
    apt-get autoremove -y python-pip mercurial

# install node-red
RUN apt-get install -y build-essential && \
    npm install -g --unsafe-perm  node-red && \
    npm install node-red-contrib-googlechart && \
    npm install node-red-node-web-nodes && \
    apt-get autoremove -y build-essential

# install nodered nodes
RUN touch /usr/share/doc/python-rpi.gpio
COPY ./source /usr/local/lib/node_modules/node-red/nodes/core/hardware
RUN chmod 777 /usr/local/lib/node_modules/node-red/nodes/core/hardware/nrgpio

WORKDIR /root/bin
RUN ln -s /usr/bin/python2 ~/bin/python
RUN ln -s /usr/bin/python2-config ~/bin/python-config
env PATH ~/bin:$PATH

# run application
EXPOSE 1880
#CMD ["/bin/bash"]
ENTRYPOINT ["node-red-pi","-v","--max-old-space-size=128"]
