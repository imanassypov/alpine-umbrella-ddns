FROM alpine:latest
COPY entrypoint.sh /entrypoint.sh
COPY updateip.sh /updateip.sh
COPY crontab.txt /crontab.txt

RUN chmod +x /updateip.sh
RUN chmod +x /entrypoint.sh
RUN /usr/bin/crontab /crontab.txt

RUN apk --no-cache --update --verbose add bash curl util-linux \
   && rm -rf /var/cache/apk/* /tmp/* /sbin/halt /sbin/poweroff /sbin/reboot

ENTRYPOINT ["/entrypoint.sh"]
