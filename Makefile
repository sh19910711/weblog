VERSION=0.1.0

.PHONY: image push prod dev spec admin zeppelin ec2 console

build:
	docker build -t sh19910711/homepage .
	docker tag sh19910711/homepage sh19910711/homepage:$(VERSION)

push: build
	docker push sh19910711/homepage:$(VERSION)

prod: build
	docker run \
		--rm \
		--name homepage \
		-e AWS_REGION=us-east-1 \
		-e DATABASE_HOST=database.homepage2 \
		-e SEARCH_HOST=search.homepage2 \
		-e RACK_ENV=production \
		-e S3_BUCKET=hiroyuki.sano.ninja \
		-e S3_PREFIX=zeppelin/ \
		-v $(HOME)/.aws:/root/.aws \
		-p 8080:8080 \
		-ti \
		sh19910711/homepage:latest

dev: build
	docker build -t sh19910711/homepage:development ./dev
	docker run \
		--rm \
		--name homepage \
		-e DATABASE_HOST=database.homepage2 \
		-e SEARCH_HOST=search.homepage2 \
		-e AWS_REGION=us-east-1 \
		-e RACK_ENV=development \
		-e S3_BUCKET=hiroyuki.sano.ninja \
		-e S3_PREFIX=zeppelin/ \
		-v $(HOME)/.aws:/root/.aws \
		-v $(PWD):/wrk \
		-v $(HOME)/.w3m:/root/.w3m \
		-p $(PORT):8080 \
		-ti \
		sh19910711/homepage:development

dev/mysql:
	docker run \
		--rm \
		--name mysql \
		--memory 100MB \
		--memory-swap 100MB \
		-p 3306:3306 \
		-v /tmp/docker/mysql:/var/lib/mysql \
		-e MYSQL_ROOT_PASSWORD=mysql \
		mariadb:10.4.1

dev/mysql/dump:
	mysqldump -h database.homepage2 -uroot -pmysql homepage | gzip - | aws s3 cp - s3://hiroyuki.sano.ninja/tmp/mysql/dump.sql.gz

dev/mysql/restore:
	echo 'create database homepage;' | docker exec -i mysql mysql
	aws s3 cp s3://hiroyuki.sano.ninja/tmp/mysql/dump.sql.gz - | zcat | docker exec -i mysql mysql homepage

dev/mysql/grant:
	cat ./database/sql/grant_user.sql | docker exec -i mysql mysql

dev/search:
	docker run \
		--rm \
		--name search \
		 -v /tmp/docker/search:/usr/share/elasticsearch/data \
		 -e discovery.type="single-node" \
		 -e indices.fielddata.cache.size="0" \
		 -e ES_JAVA_OPTS="-Xms64m -Xmx64m" \
		 -p 9200:9200 \
		docker.elastic.co/elasticsearch/elasticsearch:6.5.4

dev/search/init:
	docker exec homepage bundle exec ruby -Ilib ./database/search/create_homepage.rb

.PHONY: spec spec/all
spec:
	docker exec -e DATABASE_USERNAME -e DATABASE_PASSWORD homepage bundle exec rspec -t ~e2e

spec/all:
	docker exec -e DATABASE_USERNAME -e DATABASE_PASSWORD homepage bundle exec rspec

.PHONY: admin
admin:
	docker exec -ti -e TERM=xterm homepage w3m http://localhost:8080/admin

zeppelin:
	docker run \
		--name zeppelin \
		--rm \
		-ti \
		-p 8080:8080 \
		-v $(HOME)/.aws:/root/.aws \
		-v /home/ec2-user/.ssh:/root/.ssh \
		-e ZEPPELIN_NOTEBOOK_STORAGE=org.apache.zeppelin.notebook.repo.S3NotebookRepo \
		-e ZEPPELIN_NOTEBOOK_S3_BUCKET=hiroyuki.sano.ninja \
		-e ZEPPELIN_NOTEBOOK_S3_USER=zeppelin \
		-e ZEPPELIN_INTERPRETER_OUTPUT_LIMIT=10240000 \
		apache/zeppelin:0.8.1

zeppelin2: /tmp/zeppelin
	ZEPPELIN_NOTEBOOK_STORAGE=org.apache.zeppelin.notebook.repo.S3NotebookRepo \
	ZEPPELIN_NOTEBOOK_S3_BUCKET=hiroyuki.sano.ninja \
	ZEPPELIN_NOTEBOOK_S3_USER=zeppelin \
	ZEPPELIN_INTERPRETER_OUTPUT_LIMIT=10240000 \
	/tmp/zeppelin/zeppelin-0.8.1-bin-all/bin/zeppelin.sh

/tmp/zeppelin:
	mkdir /tmp/zeppelin && \
		cd /tmp/zeppelin && \
		curl https://www-eu.apache.org/dist/zeppelin/zeppelin-0.8.1/zeppelin-0.8.1-bin-all.tgz | tar zxvf -

setup/amazonlinux:
	sudo yum install vim tmux docker
	sudo usermod -a -G docker ec2-user
	sudo service docker restart
