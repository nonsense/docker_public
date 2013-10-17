FROM base
 
# elasticsearch
RUN apt-get update
RUN apt-get install -y jetty

# setup vol's
RUN mkdir /data
RUN mkdir /logs
VOLUME [ "/logs" ]
VOLUME [ "/data" ]

# ports
EXPOSE 8080

CMD cd /usr/share/jetty/; java -jar /usr/share/jetty/start.jar /usr/share/jetty/etc/jetty.xml
