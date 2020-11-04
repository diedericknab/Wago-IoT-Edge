FROM ubuntu:bionic as base

COPY resources /

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y apt-transport-https
RUN apt-get install -y gnupg
RUN apt-get install -y systemd
RUN curl https://packages.microsoft.com/config/debian/stretch/multiarch/prod.list > ./microsoft-prod.list
RUN cp ./microsoft-prod.list /etc/apt/sources.list.d/
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
RUN cp ./microsoft.gpg /etc/apt/trusted.gpg.d/
RUN apt-get update
RUN apt-get install -y moby-engine
RUN apt-get install -y libiothsm-std
RUN apt-get install -y iotedge
RUN apt-get remove -y moby-engine
RUN apt-get -y autoremove

RUN apt-get clean && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

FROM scratch as final
COPY --from=base / /
WORKDIR /
CMD ["./iot-edge-starter"]
