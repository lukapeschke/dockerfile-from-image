FROM alpine

RUN  apk add --update python3 wget \
     && wget -O - --no-check-certificate https://bootstrap.pypa.io/get-pip.py | python3 \
     && apk del wget \
     && pip3 install -U docker-py \
     && yes | pip3 uninstall pip

COPY entrypoint.py /root

ENTRYPOINT ["/root/entrypoint.py"]
