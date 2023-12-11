FROM alpine

RUN apk add --update python3 wget \
     && wget --no-check-certificate https://bootstrap.pypa.io/get-pip.py \
     && python3 get-pip.py --break-system-packages \
     && apk del wget \
     && pip3 install --break-system-packages -U docker \
     && rm -f get-pip.py \
     && yes | pip3 uninstall --break-system-packages pip

COPY entrypoint.py /root

ENTRYPOINT ["/root/entrypoint.py"]
