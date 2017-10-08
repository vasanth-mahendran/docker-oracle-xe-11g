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
ADD dumps /dumps
RUN /assets/setup.sh

EXPOSE 22
EXPOSE 1521
EXPOSE 8080

ADD init.sql /docker-entrypoint-initdb.d/

CMD /usr/sbin/startup.sh && bin/bash -c "/u01/app/oracle/product/11.2.0/xe/bin/imp ATGCORE/ATGCORE FILE=/dumps/core.dmp FULL=y" && bin/bash -c "/u01/app/oracle/product/11.2.0/xe/bin/imp ATGCATALOGA/ATGCATALOGA FILE=/dumps/cata.dmp FULL=y" && bin/bash -c "/u01/app/oracle/product/11.2.0/xe/bin/imp ATGCATALOGB/ATGCATALOGB FILE=/dumps/catb.dmp FULL=y" && bin/bash -c "/u01/app/oracle/product/11.2.0/xe/bin/imp ATGPUBCORE/ATGPUBCORE FILE=/dumps/pubcore.dmp FULL=y" && /usr/sbin/sshd -D
