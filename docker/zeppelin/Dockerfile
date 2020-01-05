FROM openjdk:8-slim

ENV Z_VERSION="0.8.1"

RUN apt update && apt install -y curl python3 python3-pip
RUN curl /tmp/zeppelin-${Z_VERSION}-bin-all.tgz http://archive.apache.org/dist/zeppelin/zeppelin-${Z_VERSION}/zeppelin-${Z_VERSION}-bin-netinst.tgz | tar zxvf -
WORKDIR zeppelin-${Z_VERSION}-bin-netinst
RUN ./bin/install-interpreter.sh --name md,shell,jdbc,python
RUN cp /usr/bin/python3 /usr/bin/python
