VERSION=0.1.1

.PHONY: image push prod dev spec admin zeppelin ec2 console

build:
	docker build -t sh19910711/homepage .
	docker tag sh19910711/homepage sh19910711/homepage:$(VERSION)

	cd docker/mysql && \
		docker build -t sh19910711/homepage_database . && \
		docker tag sh19910711/homepage_database sh19910711/homepage_database:$(VERSION)

	cd docker/search && \
		docker build -t sh19910711/homepage_search . && \
		docker tag sh19910711/homepage_search sh19910711/homepage_search:$(VERSION)

	cd docker/commands && \
		docker build -t sh19910711/homepage_commands . && \
		docker tag sh19910711/homepage_commands sh19910711/homepage_commands:$(VERSION)

push: build
	docker push sh19910711/homepage:$(VERSION)
	docker push sh19910711/homepage_database:$(VERSION)
	docker push sh19910711/homepage_search:$(VERSION)
	docker push sh19910711/homepage_commands:$(VERSION)

/usr/local/bin/docker-compose:
	sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(shell uname -s)-$(shell uname -m)" -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
	docker-compose --version

dev: build /usr/local/bin/docker-compose
	VERSION=$(VERSION) docker-compose up -d

dev/mysql/dump:
	docker-compose exec database mysqldump  -uroot -pmysql homepage | gzip - | aws s3 cp - s3://hiroyuki.sano.ninja/tmp/mysql/dump.sql.gz

dev/mysql/restore:
	timeout --foreground -s SIGKILL 60 bash -c "until docker-compose exec -T database mysqladmin ping -pmysql; do echo waiting-database; sleep 5; done" || exit 1
	cat database/sql/setup.sql | docker-compose exec -T database mysql -pmysql
	aws s3 cp s3://hiroyuki.sano.ninja/tmp/mysql/dump.sql.gz - | zcat | docker-compose exec -T database mysql -pmysql homepage

dev/search/restore:
	timeout --foreground -s SIGKILL 60 bash -c "until docker-compose exec -T search curl http://localhost:9200; do echo waiting-search; sleep 5; done" || exit 1
	aws s3 cp s3://hiroyuki.sano.ninja/tmp/search/init_search.bash - | docker-compose exec -T search bash

.PHONY: spec spec/all
test: dev
	timeout --foreground -s SIGKILL 60 bash -c "until docker-compose exec -T search curl http://localhost:9200; do echo waiting-search; sleep 5; done" || exit 1
	timeout --foreground -s SIGKILL 60 bash -c "until docker-compose exec -T database mysqladmin ping -pmysql; do echo waiting-database; sleep 5; done" || exit 1

	cat database/sql/setup.sql | docker exec -i $(shell docker-compose ps -q database) mysql -pmysql
	docker-compose exec -T database mysql -pmysql -e 'select count(1) from homepage.notes' || \
		cat database/sql/create_notes.sql | docker exec -i $(shell docker-compose ps -q database) mysql -pmysql
	docker-compose run \
		-v $(PWD):/wrk \
		-e DATABASE_USERNAME=root \
		-e DATABASE_PASSWORD=mysql \
		web \
		ash -c "bundle install -j4 --with development && bundle exec rspec -t ~e2e"

spec/all:
	docker-compose exec web bundle exec rspec

setup/amazonlinux:
	sudo yum install vim tmux docker
	sudo usermod -a -G docker ec2-user
	sudo service docker restart
