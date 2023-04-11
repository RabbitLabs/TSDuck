FROM ubuntu:22.10
LABEL maintener="gilles@rabbitlabs.com"
LABEL description="TS Duck Docker image for Ubuntu 22.10 with S3 bucket support"
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
 && apt-get upgrade -y\
 && apt-get install -y\
      wget \
      libsrt1.5-openssl \
      libedit2 \
      libcurl4 \
      libusb-1.0 \
      libpcsclite1 \
      s3cmd
RUN wget https://github.com/tsduck/tsduck/releases/download/v3.33-3139/tsduck_3.33-3139.ubuntu22_amd64.deb
RUN dpkg -i tsduck_3.33-3139.ubuntu22_amd64.deb
RUN mkdir /data /autorun
COPY ./run.sh /run.sh
CMD ["/run.sh"]
# expose range of ports for incoming streams
EXPOSE 5000-5100
