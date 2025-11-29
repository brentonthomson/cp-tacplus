ARG from=alpine:latest
FROM ${from} AS build

WORKDIR /
RUN apk upgrade -Ua && \
    apk add --no-cache build-base freeradius-client-dev linux-pam-dev perl pcre2-dev && \
    wget https://github.com/MarcJHuber/event-driven-servers/archive/refs/heads/master.zip -O event-driven-servers-master.zip && \
    unzip event-driven-servers-master.zip && \
    cd event-driven-servers-master && \
    ./configure --minimal tac_plus-ng && \
    make && \
    make install
	
FROM ${from}

WORKDIR /

COPY --from=build /usr/lib/libpcre2-8.so.0 /usr/lib/libpcre2-8.so.0
COPY --from=build /usr/local/lib/ /usr/local/lib/
COPY --from=build /usr/local/sbin/ /usr/local/sbin/
COPY . .

EXPOSE 49

RUN chmod +x entrypoint.sh

HEALTHCHECK --start-period=1m --interval=5m \ 
    CMD netstat -an | grep 49 > /dev/null; if [ 0 != $? ]; then exit 1; fi;

ENTRYPOINT ["/entrypoint.sh"]
CMD ["cp-tacplus.cfg"]
