FROM centos:7

RUN yum update -y && \
      yum install wget -y && \
      yum install perl-Digest-SHA -y && \
      yum install java-1.8.0-openjdk.x86_64 -y

WORKDIR /usr/elastic/

RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.13.3-linux-x86_64.tar.gz && \
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.13.3-linux-x86_64.tar.gz.sha512

RUN shasum -a 512 -c elasticsearch-7.13.3-linux-x86_64.tar.gz.sha512 && \
tar -xzf elasticsearch-7.13.3-linux-x86_64.tar.gz

RUN groupadd -g 3000 elasticsearch && \
    adduser -u 3000 -g elasticsearch -s /bin/sh elasticsearch && \
    chmod 777 -R /var/lib/ && \
    mkdir /var/lib/snapshots &&\
    chmod 777 -R /var/lib/snapshots && \
    chmod 777 -R /usr/elastic/elasticsearch-7.13.3/

USER 3000
EXPOSE 9200
EXPOSE 9300

WORKDIR /usr/elastic/elasticsearch-7.13.3/bin/

CMD ["./elasticsearch", "-Enode.name=netology_test","-Epath.data=/var/lib/data","-Epath.repo=/var/lib/snapshots", "-Epath.logs=/var/lib/logs", "-Enetwork.host=0.0.0.0", "-Ediscovery.type=single-node"]