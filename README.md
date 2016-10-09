# Dockerfile from image

## How To

The goal of this project is to easily generate a Dockerfile from an existing
Docker image.

To build the image from source:

    git clone https://github.com/lukapeschke/dockerfile-from-image.git
    cd dockerfile-from-image
    docker build -t lukapeschke/dfa .

To get a Dockerfile from an existing image:

    docker run --rm -v '/var/run/docker.sock:/var/run/docker.sock' lukapeschke/dfa <IMAGE_ID>

## Example with the official ubuntu image:

    $ docker images
    REPOSITORY          TAG                 IMAGE ID            CREATED
    ubuntu              latest              c73a085dc378        12 days ago

    $ docker run  --rm -v '/var/run/docker.sock:/var/run/docker.sock' lukapeschke/dfa c73a085dc378
    FROM ubuntu:latest
    ADD file:cd937b840fff16e04e1f59d56f4424d08544b0bb8ac30d9804d25e28fb15ded3 in /
    RUN /bin/sh -c set -xe 							     \
    	&& echo '#!/bin/sh' > /usr/sbin/policy-rc.d 			     \
    	&& echo 'exit 101' >> /usr/sbin/policy-rc.d 			     \
    	&& chmod +x /usr/sbin/policy-rc.d					\
    	&& dpkg-divert --local --rename --add /sbin/initctl 		\
    	&& cp -a /usr/sbin/policy-rc.d /sbin/initctl 		\
    	&& sed -i 's/^exit.*/exit 0/' /sbin/initctl			\
    	&& echo 'force-unsafe-io' > /etc/dpkg/dpkg.cfg.d/docker-apt-speedup			\
    	&& echo 'DPkg::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };' > /etc/apt/apt.conf.d/docker-clean	\
    	&& echo 'APT::Update::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };' >> /etc/apt/apt.conf.d/docker-clean	\
    	&& echo 'Dir::Cache::pkgcache ""; Dir::Cache::srcpkgcache "";' >> /etc/apt/apt.conf.d/docker-clean 	   			\
    	&& echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/docker-no-languages							\
    	&& echo 'Acquire::GzipIndexes "true"; Acquire::CompressionTypes::Order:: "gz";' > /etc/apt/apt.conf.d/docker-gzip-indexes		\
    	&& echo 'Apt::AutoRemove::SuggestsImportant "false";' > /etc/apt/apt.conf.d/docker-autoremove-suggests
    RUN /bin/sh -c rm -rf /var/lib/apt/lists/*
    RUN /bin/sh -c sed -i 's/^#\s*\(deb.*universe\)$/\1/g' /etc/apt/sources.list
    RUN /bin/sh -c mkdir -p /run/systemd \
        && echo 'docker' > /run/systemd/container
    CMD ["/bin/bash"]
