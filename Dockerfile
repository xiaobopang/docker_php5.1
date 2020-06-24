FROM debian:wheezy

RUN printf "deb http://archive.debian.org/debian/ wheezy main non-free contrib\ndeb-src http://archive.debian.org/debian/ wheezy main non-free contrib\ndeb http://archive.debian.org/debian-security/ wheezy/updates main non-free contrib\ndeb-src http://archive.debian.org/debian-security/ wheezy/updates main non-free contrib" > /etc/apt/sources.list \
    && apt-get -o Acquire::Check-Valid-Until=false update \
    && apt-get install -y --force-yes libssh2-1 libssh2-1-dev wget \
    && apt-get build-dep -y php5

RUN cd /tmp \
    && wget --no-check-certificate http://www.openssl.org/source/openssl-0.9.8x.tar.gz \
    && tar xvfz openssl-0.9.8x.tar.gz \
    && cd openssl-0.9.8x \
    && ./config shared --prefix=/usr/local/openssl-0.9.8 \
    && make \
    && make install

RUN cd /tmp \
    && wget --no-check-certificate https://museum.php.net/php5/php-5.1.6.tar.gz \
    && tar xvf php-5.1.6.tar.gz \
    && cd php-5.1.6 \
    && sed -i 's/__GMP_BITS_PER_MP_LIMB/GMP_LIMB_BITS/g' ext/gmp/gmp.c \
    && ./configure \
       --with-mhash \
       --with-mcrypt \
       --enable-inline-optimization \
       --with-gmp \
       --enable-bcmath \
       --with-pcre-regex \
       --with-openssl=/usr/local/openssl-0.9.8 \
       --with-openssl-dir=/usr/local/openssl-0.9.8 \
     && make \
     && make install-cli