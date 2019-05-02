FROM centos:7

RUN yum install -y wget
RUN yum groupinstall -y "Development Tools"

# apache
RUN yum install -y httpd
RUN yum install -y mod_fcgid
RUN useradd -U -s /sbin/nologin httpd
EXPOSE 80

# perl
RUN yum install -y perl  # TODO: latest
RUN yum install -y perl-devel
RUN yum install -y perl-App-cpanminus

# mobasif
RUN wget -P /tmp https://github.com/ken1flan/mobaif_sample/archive/master.zip
RUN unzip /tmp/master.zip -d /tmp
RUN cd /tmp/mobaif_sample-master/src/xs && ./makexs MobaConf
RUN cd /tmp/mobaif_sample-master/src/xs && ./makexs MTemplate
RUN cd /tmp/mobaif_sample-master/src/xs && ./makexs Mcode
RUN cd /tmp/mobaif_sample-master/src/xs && ./makexs SoftbankEncode
RUN cd /tmp/mobaif_sample-master/src/xs && ./makexs HTMLFast

# Run
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
