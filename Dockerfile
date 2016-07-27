FROM anapsix/alpine-java:8

RUN apk add --update git curl nodejs python ruby && rm -rf /var/cache/apk/*

#Install Clojure
ENV LEIN_ROOT 1
ENV HTTP_CLIENT curl -k -s -f -L -o

RUN curl --silent --location --retry 3 --insecure https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein --output /usr/bin/lein && chmod 0755 /usr/bin/lein
RUN /usr/bin/lein upgrade

#Open Ports
EXPOSE 3000 80 8080

#Copy checkout script to root directory
COPY config/checkout.sh /root/
RUN chmod +x /root/checkout.sh

ENTRYPOINT ["/root/checkout.sh"]
