## This repository holds a docker recipe for the freedb server.


[![Build Status](https://travis-ci.org/spielhuus/docker-freedb-server.svg?branch=master)](https://travis-ci.org/spielhuus/docker-freedb-server)
[![GitHub version](https://badge.fury.io/gh/spielhuus%2Fdocker-freedb-server.svg)](https://hub.docker.com/r/spielhuus/freedb-server)

[Docker](https://docker.io/) recipe for [freedb-server](http://www.freedb.org/en/download__server_software.4.html) project

### Create an image 

```
docker pull spielhuus/freedb-server
docker run --name cddbd -p 8888:8888 -itd \
           spielhuus/freedb-server
```

The first startup will take some while because the database file are downloaded and indexed for fuzzy search. 
The database directory can be mounted to /usr/local/cddb.

### Configure the client

configure the freedb client of your choice:

```
http://<host>:8888/cddb.cgi
```


### Credits:

* https://docker.io
* https://freedb.org

### License 

[Boost Software License](http://www.boost.org/LICENSE_1_0.txt) - Version 1.0 - August 17th, 2003

