FROM ubuntu:18.04
EXPOSE 80
EXPOSE 443
EXPOSE 8043
EXPOSE 8443
EXPOSE 8003
EXPOSE 3000/udp
EXPOSE 5000/udp
EXPOSE 22
RUN apt-get update
RUN apt-get ssh install bash sudo wget -y
RUN wget -q -O - https://lsrelay-extensions-production.s3-us-west-2.amazonaws.com/relay-rocket/rr-setup.sh | sudo dns="172.16.1.2 172.16.1.3" token="c5c4af5f-cd6e-4329-9841-4f3d7658ae36" bash
