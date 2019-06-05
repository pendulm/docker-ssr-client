FROM golang:latest as builder

RUN wget http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.tar.gz -O /tmp/GeoLite2-Country.tar.gz && \
    tar zxvf /tmp/GeoLite2-Country.tar.gz -C /tmp && \
    mv /tmp/GeoLite2-Country_*/GeoLite2-Country.mmdb /Country.mmdb

WORKDIR /clash-src
RUN git clone https://github.com/Dreamacro/clash.git /clash-src && \
    git checkout v0.14.0 && \
    go mod download && \
    GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -ldflags '-w -s' -o /clash

FROM alpine

ENV RUNUSER="admin"
WORKDIR "/home/${RUNUSER}"

RUN set -x \
    && echo -e "https://mirrors.ustc.edu.cn/alpine/latest-stable/main\nhttps://mirrors.ustc.edu.cn/alpine/latest-stable/community" > /etc/apk/repositories \
    && apk update \
    && apk --no-cache add ca-certificates su-exec python supervisor \
    && adduser -S ${RUNUSER}

ADD ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./shadowsocks /opt/shadowsocks
COPY --from=builder /clash /usr/bin/clash
COPY conf-example  /home/admin/conf
COPY --from=builder /Country.mmdb /home/admin/conf/
COPY polipo/polipo /usr/bin/polipo
RUN chmod +x /usr/bin/polipo

ENTRYPOINT ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
