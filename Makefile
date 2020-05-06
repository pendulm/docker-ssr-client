list:
	@ls conf/ssr_config | awk -F. "{print \$$1}"| xargs

up:
	@docker-compose up -d


down:
	@docker-compose down -v

reup:
	@docker-compose down -v
	@docker-compose up -d

%:
	@cp -f conf/ssr_config/$@.json conf/ssr.json
	@docker-compose down -v
	@docker-compose up -d

.PHONY:
	list
