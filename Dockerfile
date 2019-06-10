FROM centos:7

RUN yum install -y wget
RUN yum groupinstall -y "Development Tools"

# apache
RUN yum install -y httpd
RUN yum install -y mod_fcgid
RUN mkdir /var/log/mobalog && chown apache:apache /var/log/mobalog
EXPOSE 80

# mysql
RUN yum install -y mariadb
RUN yum install -y mariadb-devel
RUN yum install -y mariadb-server
RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql

# perl
RUN yum install -y perl  # TODO: latest
RUN yum install -y perl-devel
RUN yum install -y perl-App-cpanminus
RUN cpanm CGI::Fast
RUN cpanm DBI
RUN cpanm DBD::MariaDB

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