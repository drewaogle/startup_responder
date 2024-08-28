FROM ubuntu:22.04

RUN apt update
RUN apt install -y cron rsyslog iputils-ping curl

ADD start_ping.sh / 
ADD ping_process.sh / 
ADD start.sh /

CMD [ "bash", "/start.sh" ]
