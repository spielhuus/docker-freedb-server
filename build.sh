#!/bin/bash

DOCKER_USER=$1
DOCKER_PASS=$2
TRAVIS_BRANCH=$3

mkdir $(pwd)/target
CDDB_VERSION=1.5.2
echo  http://ftp.freedb.org/pub/freedb/cddbd-$CDDB_VERSION.tar.gz
curl -o cddbd-$CDDB_VERSION.tar.gz http://ftp.freedb.org/pub/freedb/cddbd-$CDDB_VERSION.tar.gz
tar xfz cddbd-$CDDB_VERSION.tar.gz

sudo docker run -itd -v $(pwd)/cddbd-$CDDB_VERSION:/repo -v $(pwd)/target:/target --name freedb-server_build debian:buster-slim /bin/bash 

docker exec freedb-server_build /bin/bash -c "apt-get update -y && apt-get upgrade -y && apt-get install -y g++ gcc make pkg-config uwsgi"

#build freedb-server 
docker exec freedb-server_build /bin/bash -c "\
export ENV instsubmitcgi=\"false\" && \
mkdir -p /usr/local/bin && mkdir -p /usr/local/man/man1 && \
mkdir -p /usr/local/cddbd/cgi && cd /usr/local/cddbd && \
cd /repo && \
chmod a+x ./config.sh && \
echo | ./config.sh && \
make && \
chmod a+x ./install.sh && \
/bin/echo -e \"/usr/local/bin\n/usr/local/man/man1\n\n\n\n/usr/local/cddbd/cgi\nn\n\n\n\n\n\n\n\n\n\n\n\n\n\nn\nn\" | ./install.sh && \
tar cfz /target/cddbd-$CDDB_VERSION.tar.gz \
        /usr/local/bin/cddbd \
        /usr/local/man/man1/cddbd.1 \
        /usr/local/cddbd/cgi/cddb.cgi \
        /usr/local/cddbd/access \
        /usr/local/cddbd/sites \
        /usr/local/cddbd/passwd"

sudo docker login -u $DOCKER_USER -p $DOCKER_PASS
export REPO=spielhuus/freedb-server
export TAG=`if [ "$TRAVIS_BRANCH" == "master" ]; then echo "latest"; else echo $TRAVIS_BRANCH ; fi`
docker build -f Dockerfile -t $REPO:$TAG . --build-arg CDDB_VERSION=$CDDB_VERSION
sudo docker push $REPO


