# centOS 7 설치
FROM centos
MAINTAINER donghee kim <heeya.kim@navercorp.com>

### 의존 패키지 설치
USER root
RUN yum install -y epel-release wget net-tools tree sudo gcc gcc-c++ libtool

### 초기 설정
RUN mkdir /home1
RUN useradd -m -d /home1/irteam irteam
RUN useradd -m -d /home1/irteamsu irteamsu
RUN chmod 755 /home1/irteam
RUN chmod 755 /home1/irteamsu
# echo 'newpassword' | passwd root --stdin
RUN echo 'irteamsu ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

USER irteamsu
RUN sudo yum install -y openssl openssl-devel
RUN sudo yum install -y zlib-devel curl-devel
RUN sudo yum install -y curl libxml2-devel
RUN sudo yum install -y pcre-devel
RUN sudo yum groupinstall -y "Development Tools"

### 환경 변수 설정
USER irteam
RUN mkdir ~/apps
RUN echo 'export LC_ALL=ko_KR.UTF-8' >> ~/.bashrc
RUN echo 'export LANG=ko_KR.UTF-8' >> ~/.bashrc 
RUN echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bashrc 
RUN echo 'export LD_LIBRARY_PATH=/home1/irteam/apps/tomcat/lib/native/lib:$LD_LIBRARY_PATH' >> ~/.bashrc 
RUN source ~/.bashrc

### apache 설치
USER root
RUN sudo yum install -y gcc expat-devel iptables
# RUN cd /sbin/\
# && sudo iptables -I INPUT -p tcp --dport 80 -j ACCEPT\
# && sudo iptables -A INPUT -i docker0 -j ACCEPT

USER irteam
RUN cd ~/apps\
&& wget http://apache.mirror.cdnetworks.com//httpd/httpd-2.4.29.tar.gz\
&& wget http://mirror.apache-kr.org//apr/apr-1.6.3.tar.gz\
&& wget http://mirror.apache-kr.org//apr/apr-util-1.6.1.tar.gz\
&& wget http://mirror.apache-kr.org//apr/apr-iconv-1.2.2.tar.gz\
&& wget http://downloads.sourceforge.net/project/pcre/pcre/8.41/pcre-8.41.tar.gz\
&& tar xvzf httpd-2.4.29.tar.gz\
&& tar xvzf apr-1.6.3.tar.gz\
&& tar xvzf apr-util-1.6.1.tar.gz\
&& tar xvzf apr-iconv-1.2.2.tar.gz\
&& tar xvzf pcre-8.41.tar.gz\ 
&& ln -s apr-1.6.3 apr\
&& ln -s apr-iconv-1.2.2 apr-iconv\
&& ln -s apr-util-1.6.1 apr-util\
&& mv apr-1.6.3 ./httpd-2.4.29/srclib/apr\
&& mv apr-util-1.6.1 ./httpd-2.4.29/srclib/apr-util\
&& mkdir pcre\
&& cd pcre-8.41\
&& ./configure --prefix=/home1/irteam/apps/pcre\
&& cd /home1/irteam/apps/httpd-2.4.29\
&& ./configure --prefix=/home1/irteam/apps/apache-2.4.29\
&& make && make install\
&& cd /home1/irteam/apps\
&& ln -s apache-2.4.29 apache
RUN echo 'ServerName localhost' >> /home1/irteam/apps/apache/conf/httpd.conf

### root로 로그인
USER root
RUN cd /home1/irteam/apps/apache/bin\
&& sudo chown root:irteam httpd\
&& sudo chmod 4755 httpd

USER irteam
RUN /home1/irteam/apps/apache/bin/apachectl start

###tomcat 설치
USER irteam
RUN cd /home1/irteam/apps\
&& wget http://mirror.navercorp.com/apache/tomcat/tomcat-8/v8.5.24/bin/apache-tomcat-8.5.24.tar.gz\
&& tar xvzf apache-tomcat-8.5.24.tar.gz\
&& ln -s apache-tomcat-8.5.24 tomcat\

### django 설치
USER irteamsu
RUN sudo yum install -y xz xz-devel python-tools python3-tkinter

USER irteam
RUN cd ~/apps\
&& wget 'https://www.python.org/ftp/python/3.5.1/Python-3.5.1.tgz'\
&& tar xvzf Python-3.5.1.tgz\
&& cd Python-3.5.1\
&& ./configure --prefix=/home1/irteam/apps/python_3.5.1 --enable-shared --with-system-ffi --with-threads --with-zlib\
&& make\
&& make install\
&& chmod -v 755 /home1/irteam/apps/python_3.5.1/lib/libpython3.5m.so\
&& chmod -v 755 /home1/irteam/apps/python_3.5.1/lib/libpython3.so

RUN echo 'export LD_LIBRARY_PATH=/home1/irteam/apps/python_3.5.1/lib:$LD_LIBRARY_PATH' >> ~/.bashrc
RUN source ~/.bashrc

USER irteam
RUN cd ~/apps\
&& wget -O mod_wsgi-4.4.21.tar.gz https://github.com/GrahamDumpleton/mod_wsgi/archive/4.4.21.tar.gz\
&& tar xvzf mod_wsgi-4.4.21.tar.gz\
&& cd mod_wsgi-4.4.21\
&& ./configure --with-apxs=/home1/irteam/apps/apache/bin/apxs\
&& make\
&& make install
RUN echo 'LoadModule wsgi_module modules/mod_wsgi.so' >> /home1/irteam/apps/apache/conf/httpd.conf

EXPOSE 80
EXPOSE 443
