FROM fscm/debian:stretch as build

ARG BUSYBOX_VERSION="1.30.0"
ARG PACKER_VERSION="1.4.1"
ARG PYTHON_VERSION="3.7.3"
ARG PYTHON_PIP_VERSION="19.1"
ARG TERRAFORM_VERSION="0.12.0"

ENV \
  LANG=C.UTF-8 \
  DEBIAN_FRONTEND=noninteractive

COPY files/ /root/

RUN \
  apt-get -qq update && \
  apt-get -qq -y -o=Dpkg::Use-Pty=0 --no-install-recommends install \
    autoconf \
    autotools-dev \
    bsdtar \
    bzip2 \
    ca-certificates \
    curl \
    dnsutils \
    g++ \
    gcc \
    groff-base \
    libbluetooth-dev \
    libbz2-dev \
    libc-dev \
    libc6-dev \
    libdb-dev \
    libdb5.3-dev \
    libexpat1-dev \
    libffi-dev \
    libgdbm-dev \
    libgpm2 \
    liblzma-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    libtinfo-dev \
    llvm \
    lsb-release \
    make \
    netbase \
    tar \
    tk-dev \
    uuid-dev \
    xz-utils \
    zlib1g-dev && \
  sed -i '/path-include/d' /etc/dpkg/dpkg.cfg.d/90docker-excludes && \
  mkdir -p /build/work && \
  mkdir -m 1777 /build/tmp && \
  mkdir -p /src/apt/dpkg && \
  chmod -R o+rw /src/apt && \
  cp -r /var/lib/dpkg/* /src/apt/dpkg/ && \
  cd /src/apt && \
  apt-get -qq -y -o=Dpkg::Use-Pty=0 download bash groff-base && \
  dpkg --unpack --force-all --no-triggers --instdir=/build --admindir=/src/apt/dpkg --path-exclude="/etc*" --path-exclude="/usr/share*" bash_*.deb && \
  dpkg --unpack --force-all --no-triggers --instdir=/build --admindir=/src/apt/dpkg --path-exclude="/etc*" --path-exclude="/usr/lib*" --path-exclude="/usr/share/doc*" --path-exclude="/usr/share/man*" groff-base_*.deb && \
  ln -s /bin/bash /build/bin/sh && \
  for f in `find /build -name '*.dpkg-new'`; do mv "${f}" "${f%.dpkg-new}"; done && \
  cd - && \
  mkdir -p /src/python && \
  curl -fsSL --retry 3 --insecure "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-${PYTHON_VERSION}.tgz" | tar xz --no-same-owner --strip-components=1 -C /src/python/ && \
  cd /src/python && \
  CFLAGS="-Wdate-time -D_FORTIFY_SOURCE=2 -g -fstack-protector-strong -Wformat -Werror=format-security" LDFLAGS="-Wl,-z,relro" ./configure \
    --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    --quiet \
    --prefix="" \
    --enable-ipv6 \
    --enable-loadable-sqlite-extensions \
    --enable-shared \
    --with-system-expat \
    --with-system-ffi \
    --without-ensurepip && \
  make --silent && \
  make --silent install DESTDIR=/build INSTALL="install -p" && \
  ln -s /build/bin/python3.7 /bin/python3.7 && \
  curl -sL --retry 3 --insecure "https://bootstrap.pypa.io/get-pip.py" | LD_LIBRARY_PATH=/build/lib python3.7 - --disable-pip-version-check --no-warn-script-location --no-cache-dir "pip==${PYTHON_PIP_VERSION}" && \
  ln -s /build/bin/pip3.7 /bin/pip3.7 && \
  LD_LIBRARY_PATH=/build/lib CFLAGS=-I/build/include CPPFLAGS=-I/build/include LDFLAGS=-L/build/lib pip3.7 install --disable-pip-version-check --no-warn-script-location --no-cache-dir awscli s3cmd azure-cli && \
  find /build/ -depth \( \( -type d -a \( -name test -o -name tests -o -name __pycache__ \) \) -o \( -type f -a \( -name '*.pyc' -o -name '*.pyo' -o -name '*.bat' \) \) \) -exec rm -rf '{}' + && \
  for p in $(find /build/bin/ -type f); do s="$(basename ${p})"; t="$(dirname ${p})/$(echo ${s} | sed 's/-3.7//;s/3.7m//;s/3.7//')"; if [ ! -f "${t}" ]; then ln -s "${s}" "${t}"; fi; done && \
  cd - && \
  curl -fsSL --retry 3 --insecure "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip" | bsdtar xf - --strip-components=0 --no-same-permissions --no-same-owner -C /build/bin/ && \
  chmod 0755 /build/bin/packer && \
  curl -fsSL --retry 3 --insecure "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" | bsdtar xf - --strip-components=0 --no-same-permissions --no-same-owner -C /build/bin/ && \
  chmod 0755 /build/bin/terraform && \
  rm -rf /build/include /build/share && \
  mkdir -p /build/run/systemd && \
  echo 'docker' > /build/run/systemd/container && \
  curl -fsSL --retry 3 --insecure "https://raw.githubusercontent.com/fscm/tools/master/lddcp/lddcp" -o ./lddcp && \
  chmod +x ./lddcp && \
  ./lddcp $(for f in `find /build/ -type f -executable`; do echo "-p $f "; done) $(for f in `find /lib/x86_64-linux-gnu/ \( -name 'libnss*' -o -name 'libresolv*' \)`; do echo "-l $f "; done) -d /build && \
  curl -fsSL --retry 3 --insecure "https://busybox.net/downloads/binaries/${BUSYBOX_VERSION}-i686/busybox" -o /build/bin/busybox && \
  chmod +x /build/bin/busybox && \
  for p in [ [[ basename cat cp date dirname du echo env grep ln ls mkdir mv ping rm sort; do ln -s busybox /build/bin/${p}; done && \
  mkdir -p /build/usr/bin && \
  ln -s /bin/env /build/usr/bin/env && \
  mkdir -p /build/usr/local && \
  chmod a+x /root/tests/* && \
  cp -R /root/tests /build/usr/local/



FROM scratch

LABEL \
  maintainer="Frederico Martins <https://hub.docker.com/u/fscm/>"

COPY --from=build \
  /build .

VOLUME ["/work"]

WORKDIR /work

ENV \
  LANG=C.UTF-8 \
  PYTHONHOME=/ \
  PYTHONDONTWRITEBYTECODE=1 \
  PACKER_CACHE_DIR=/tmp/packer_cache \
  PAGER=more
