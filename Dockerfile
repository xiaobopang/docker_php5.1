FROM centos:latest

RUN yum install -y gcc make flex patch bzip2 libxml2-devel perl httpd-devel
RUN yum -y install httpd

COPY php-5.1.6.tar.bz2 /root
WORKDIR /root
RUN tar xvf php-5.1.6.tar.bz2
WORKDIR /root/php-5.1.6

COPY simplexml.c.diff /root/php-5.1.6
COPY documenttype.c.diff /root/php-5.1.6
COPY php_functions.c.diff /root/php-5.1.6

# See http://qiita.com/tkimura/items/55b1fc245c87ad58a941

RUN patch --ignore-whitespace ext/dom/documenttype.c < documenttype.c.diff 
RUN patch --ignore-whitespace ext/simplexml/simplexml.c < simplexml.c.diff
RUN patch --ignore-whitespace sapi/apache2handler/php_functions.c < php_functions.c.diff

RUN ./configure \
     --with-apxs2 \
     --enable-mbstring \
    && make && make install && make clean

RUN echo 'AddType application/x-httpd-php .php' >> /etc/httpd/conf/httpd.conf

RUN rm -rf /root/php-5.1.6
RUN /bin/rm /root/php-5.1.6.tar.bz2
RUN yum remove -y gcc make flex patch bzip2 libxml2-devel perl httpd-devel
RUN yum clean all