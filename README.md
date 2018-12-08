# docker-ssr-client

## usage

- port 8080 http proxy
- port 1080 sock5 proxy


```
$ make # list all config
eu1 hk1 jp1 jp2 jp3 us1 us2

$ make eu1 # switch profile
lrwxr-xr-x  1 user  staff  22 Dec  8 23:02 ssr-data/shadowsocks/config.json -> ../ssr_config/eu1.json

$ make down # stop docker
Stopping ssr ... done
Removing ssr ... done

$ make up # start docker
Creating ssr ... done
```
