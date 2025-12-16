FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y nginx && \
    apt-get install -y openssl && \
    rm -rf /var/lib/apt/lists/*

COPY ./conf/sylabbe.42.fr.conf /etc/nginx/sites-available/sylabbe.42.fr.conf

COPY SSL_gen.sh /usr/local/bin/SSL_gen.sh
RUN chmod +x /usr/local/bin/SSL_gen.sh && \
    /usr/local/bin/SSL_gen.sh

RUN ln -s /etc/nginx/sites-available/sylabbe.42.fr.conf /etc/nginx/sites-enabled/sylabbe.42.fr.conf

EXPOSE 443

CMD [ "nginx", "-g", "daemon off;" ]

