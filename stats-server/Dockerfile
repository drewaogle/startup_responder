FROM ubuntu:22.04

RUN apt update
RUN apt install -y python3-pip
RUN pip3 install flask
ADD responder.py /
EXPOSE 5000

#CMD [ "python3", "/responder.py" ]
CMD ["flask", "--app", "responder", "run", "--host=0.0.0.0"]
