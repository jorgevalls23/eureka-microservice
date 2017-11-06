FROM centos:7
MAINTAINER Jorge Valls jvalls@paradigmadigital.com

ENV APP_HOME /opt/app

ENV JAVA_VERSION 1.8.0
ENV GID 20000
# This hast to be the userId because is the one that runs openshift
ENV UID 1000040000

RUN mkdir -p $APP_HOME

RUN groupadd --gid $GID java && useradd --uid $UID -m -g java java && \
    yum -y install \
       initscripts \
       java-$JAVA_VERSION-openjdk-devel \
       procps-ng \
       strace \
       wget \
       curl && \
    yum clean all

RUN chown -R java:java $APP_HOME

RUN chmod -R +rwx $APP_HOME

LABEL io.k8s.description="Java 8 runtime for Spring boot microservices" \
	  io.openshift.expose-services="8080:http" \
      io.openshift.tags="java8,microservices,spring-boot"

ENV io.k8s.description="Java 8 runtime for Spring boot microservices" \
	io.openshift.expose-services="8080:http" \
    io.openshift.tags="java8,microservices,spring-boot"

RUN mkdir /var/log/microservices && chown java:java /var/log/microservices && chmod 777 /var/log/microservices
#RUN mkdir /LOG_PATH_IS_UNDEFINED/ && chmod 777 /LOG_PATH_IS_UNDEFINED/
#ADD application.jar $APP_HOME/

# Get the JAR file of the microservice in the repository server adding version with metadalta xml file and renaming this file to application.jar 
RUN wget --no-check-certificate https://myrepository/eureka-1.0.0-`curl --insecure https://myrepository/maven-metadata.xml | grep -m 1 "<timestamp>.*</timestamp>" | awk 'BEGIN{FS=">"}{print $2}'| awk 'BEGIN{FS="<"}{print $1}'`-1.jar -O $APP_HOME/application.jar
USER java

EXPOSE 8080

#CMD java -Xmx512m -Xms512m -DLog4jContextSelector=org.apache.logging.log4j.core.async.AsyncLoggerContextSelector -Djava.security.egd=file:/dev/./urandom -jar $APP_HOME/application.jar
CMD java -Xmx512m -Xms512m -Djava.security.egd=file:/dev/./urandom -jar $APP_HOME/application.jar
