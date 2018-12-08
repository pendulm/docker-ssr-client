list:
	@ls ssr-data/ssr_config | awk -F. "{print \$$1}"

up:
	@docker-compose up -d


down:
	@docker-compose down -v

reup:
	@docker-compose down -v
	@docker-compose up -d

%:
	@ln -sf ../ssr_config/$@.json ssr-data/shadowsocks/config.json
	@ls -l ssr-data/shadowsocks/config.json
	@docker exec -it ssr pkill -9  python

.PHONY:
	list
