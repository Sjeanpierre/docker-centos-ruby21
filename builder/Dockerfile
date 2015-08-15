FROM tcnksm/centos-ruby:2.1
RUN yum -y install rpm-build
RUN yum install -y git
RUN yum -q check-update ; yum install -y "gcc" "gcc-c++" "kernel-devel" "openssl-devel" "readline-devel" "libxml2-devel" "libxslt-devel" "libevent-devel" "postgresql-devel" "mysql-devel" "sqlite-devel"
RUN yum install -y tar
RUN gem install fpm
RUN mkdir -p /var/www/
add build.sh /
RUN chmod +x /build.sh
