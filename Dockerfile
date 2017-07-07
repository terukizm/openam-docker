FROM tomcat:8.0.45-jre8
MAINTAINER KOIZUMI Teruaki <teru.kizm [at] gmail.com>

## @see https://github.com/docker-library/tomcat/blob/fcc0cd5d0992ec4a07f5844c98b0e3112a0568de/8.0/jre8/Dockerfile
#ENV CATALINA_HOME /usr/local/tomcat

# INSTALL JDK (This Docker Image Using "JRE")
RUN apt-get update && apt-get install -y openjdk-8-jdk && rm -rf /var/lib/apt/lists/*

# OpenAM Settings for Tomcat
RUN sed -i -e 's/redirectPort="8443"/redirectPort="8443" URIEncoding="UTF-8"/g' ${CATALINA_HOME}/conf/server.xml \
  && echo 'JAVA_OPTS="-server -Xmx1024m -DJava.security.egd=file:/dev/./urandom"' > ${CATALINA_HOME}/bin/setenv.sh

# Add Tomcat User
RUN useradd -m -c "Tomcat System User" tomcat -s /bin/bash \
  && chown -R tomcat:tomcat ${CATALINA_HOME} \
  && chmod +x ${CATALINA_HOME}/bin/*.sh

# Deploy OpenAM
ENV OPENAM_VERSION=13.0.0
COPY war/OpenAM-${OPENAM_VERSION}.war ${CATALINA_HOME}/webapps/openam.war

# Mount Data Volume
RUN mkdir -p /data \
  && ln -snf /home/tomcat/openam /openam
VOLUME /openam

# Run
USER tomcat
WORKDIR ${CATALINA_HOME}
EXPOSE 8080
CMD ["bin/catalina.sh", "run"]
