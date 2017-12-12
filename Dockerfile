#build stolon
FROM golang:1.9.0-stretch

WORKDIR /go/src/github.com/sorintlab
RUN git clone https://github.com/sorintlab/stolon.git

WORKDIR /go/src/github.com/sorintlab/stolon
RUN git checkout tags/v0.7.0
RUN ./build

#package postgres with stolon and wal-e
FROM postgres:10.1

RUN apt-get update
RUN apt-get install -qqy --no-install-recommends build-essential python3 python3-setuptools python3-pip python3-dev lzop \
            $(apt-get -s dist-upgrade|awk '/^Inst.*ecurity/ {print $2}') &&\
            apt-get clean

#RUN cat /etc/apt/sources.list
#RUN apt-get install python3-dev -qqy

RUN pip3 install wheel
RUN pip3 install python-swiftclient
RUN pip3 install python-keystoneclient
RUN pip3 install setuptools python-swiftclient python-keystoneclient wal-e

WORKDIR /opt/stolon
COPY --from=0 /go/src/github.com/sorintlab/stolon/bin/* ./
RUN ls -s ./* /usr/bin/.
RUN chmod +x ./*

RUN useradd -ms /bin/bash stolon

EXPOSE 5432

ADD bin/stolon-keeper bin/stolon-sentinel bin/stolon-proxy bin/stolonctl /usr/local/bin/

RUN chmod +x /usr/local/bin/stolon-keeper /usr/local/bin/stolon-sentinel /usr/local/bin/stolon-proxy /usr/local/bin/stolonctl
