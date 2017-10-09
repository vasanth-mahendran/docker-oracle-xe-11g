FROM ubuntu:16.04

LABEL Vasanth Mahendran <vasanth.vmr@gmail.com>

# Add env variables for oracle_home and related
ENV ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe \
ORACLE_SID=XE

#Export oracle_home and related
RUN echo 'export ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe' >> etc/bash.bashrc
RUN echo 'export PATH=$ORACLE_HOME/bin:$PATH' >> /etc/bash.bashrc
RUN echo 'export ORACLE_SID=XE' >> /etc/bash.bashrc

ADD assets /assets
RUN /assets/setup.sh

EXPOSE 22
EXPOSE 1521
EXPOSE 8080

CMD /usr/sbin/startup.sh && /usr/sbin/sshd -D
