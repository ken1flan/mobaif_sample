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

# mariadb
RUN yum install -y mariadb mariadb-devel

# perl
RUN yum install -y perl  # TODO: latest
RUN yum install -y perl-devel
RUN yum install -y perl-App-cpanminus
RUN cpanm Carton

# mobasif
RUN echo "Include /usr/local/lib/mobalog/conf/httpd.conf" >>  /etc/httpd/conf/httpd.conf
RUN mkdir -p /var/log/mobalog && chown apache:apache /var/log/mobalog
COPY src/xs /tmp/xs
RUN cd /tmp/xs && ./makexs MobaConf && ./makexs MTemplate && ./makexs SoftbankEncode && ./makexs HTMLFast && ./makexs Kcode

# Test
COPY yum.repos.d/google-chrome.repo /etc/yum.repos.d
RUN yum install -y libpng libpng-devel google-chrome-stable
RUN yum install -y nmap-ncat

CMD ["/usr/sbin/init"]
