FROM debian:jessie

# install java8

RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | \

  tee /etc/apt/sources.list.d/webupd8team-java.list

RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | \

  tee -a /etc/apt/sources.list.d/webupd8team-java.list

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886

RUN apt-get update



RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections

RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections

RUN apt-get install -y oracle-java8-installer
COPY entrypoint.sh /sbin/entrypoint.sh

RUN chmod +x /sbin/entrypoint.sh

# Copy new license

#COPY ./Splunk_Enterprise_Q3FY17.lic /var/opt/splunk/etc/licenses/download-trial/Splunk_Enterprise_Q3FY17.lic
# Ports Splunk Web, Splunk Daemon, KVStore, Splunk Indexing Port, Network Input, HTTP Event Collector

EXPOSE 8000/tcp 8089/tcp 8191/tcp 9997/tcp 1514 8088/tcp

WORKDIR /opt/splunk

# Configurations folder, var folder for everything (indexes, logs, kvstore)

VOLUME [ "/opt/splunk/etc", "/opt/splunk/var" ]

ENTRYPOINT ["/sbin/entrypoint.sh"]

CMD ["start-service"]
