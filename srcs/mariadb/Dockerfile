FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y mariadb-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY db_setup.sh /usr/local/bin/db_setup.sh

RUN chmod +x /usr/local/bin/db_setup.sh

RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

ENTRYPOINT [ "/usr/local/bin/db_setup.sh" ]


