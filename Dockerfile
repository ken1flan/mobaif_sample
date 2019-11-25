FROM centos:7
ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]

RUN yum install -y wget
RUN yum groupinstall -y "Development Tools"

# apache
RUN yum install -y httpd
RUN yum install -y mod_fcgid
RUN mkdir /var/log/mobalog && chown apache:apache /var/log/mobalog
EXPOSE 80
RUN systemctl enable httpd.service

# mysql
RUN yum install -y mariadb mariadb-devel

# perl
RUN yum install -y perl  # TODO: latest
RUN yum install -y perl-devel
RUN yum install -y perl-App-cpanminus
RUN cpanm Carton

# mobasif
RUN wget -P /tmp https://github.com/ken1flan/mobasif_sample/archive/master.zip
RUN unzip /tmp/master.zip -d /tmp
RUN cd /tmp/mobasif_sample-master/src/xs && ./makexs MobaConf
RUN cd /tmp/mobasif_sample-master/src/xs && ./makexs MTemplate
RUN cd /tmp/mobasif_sample-master/src/xs && ./makexs SoftbankEncode
RUN cd /tmp/mobasif_sample-master/src/xs && ./makexs HTMLFast
RUN echo "Include /usr/local/lib/mobalog/conf/httpd.conf" >>  /etc/httpd/conf/httpd.conf
RUN mkdir -p /var/log/mobalog && chown apache:apache /var/log/mobalog

# Run
# CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
# CMD ["/usr/bin/mysqld_safe"]
CMD ["/usr/sbin/init"]