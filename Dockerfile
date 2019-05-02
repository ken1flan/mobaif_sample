FROM centos:7

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

# Run
# CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
