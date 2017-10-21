FROM alpine

RUN  apk add --update python3 wget \
     && wget --no-check-certificate https://bootstrap.pypa.io/get-pip.py \
     && apk del wget \
     && python3 get-pip.py \
     && rm get-pip.py \
     && pip3 install -U docker-py pip \
     && yes | pip3 uninstall pip

COPY entrypoint.py /root

ENTRYPOINT ["/root/entrypoint.py"]
