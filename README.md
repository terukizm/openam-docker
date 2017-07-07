# openam-docker

OpenAM with Docker

* Apache Tomcat v8.0.45
  * (OpenAM 13.0.0 needs Tomcat v8.0.x)

## Usage

### 1. [Download "OpenAM-13.0.0.war"](https://backstage.forgerock.com/downloads/OpenAM) 

Put into `war/` directory.

```
$ cd openam-docker
$ ls war/
OpenAM-13.0.0.war
```

### 2. Build 

```
$ docker build --rm -t myam-image .
```

### 3. Run

e.g.  [http://openam.docker.test:28080/openam/](http://openam.docker.test:28080/openam/)

```
$ docker run --name myam -h "openam.docker.test" -p 28080:8080 -it myam-image:latest
```

(docker-compose.yml)

```
version: '3'

services:
  openam:
    build:
      context: openam
      dockerfile: Dockerfile
    hostname: 'openam.docker.test'
    ports:
      - 28080:8080
    volumes:
      - ./.data/openam:/openam
```
