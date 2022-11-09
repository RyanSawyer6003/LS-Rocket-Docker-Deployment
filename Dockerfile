FROM ubuntu:latest

RUN apt-get install wget -y
RUN ./rocket-setup-script.sh | dns="172.16.1.2 172.16.1.3" token="c5c4af5f-cd6e-4329-9841-4f3d7658ae36" bash
