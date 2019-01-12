VERSION=0.0.22

.PHONY: image push prod dev spec admin zeppelin ec2 console

build:
	docker build -t sh19910711/homepage .
	docker tag sh19910711/homepage sh19910711/homepage:$(VERSION)

push:
	docker push sh19910711/homepage:$(VERSION)

prod: build
	docker run \
		--rm \
		--name homepage \
		-e AWS_REGION=us-east-1 \
		-e RACK_ENV=production \
		-e S3_BUCKET=hiroyuki.sano.ninja \
		-e S3_PREFIX=zeppelin/ \
		-v $(HOME)/.aws:/root/.aws \
		-p 8080:8080 \
		--link mysql \
		-ti \
		sh19910711/homepage:latest

dev: build
	docker build -t sh19910711/homepage:development ./dev
	docker run \
		--rm \
		--name homepage \
		-e AWS_REGION=us-east-1 \
		-e RACK_ENV=development \
		-e S3_BUCKET=hiroyuki.sano.ninja \
		-e S3_PREFIX=zeppelin/ \
		-v $(HOME)/.aws:/root/.aws \
		-v $(PWD):/wrk \
		-v $(HOME)/.w3m:/root/.w3m \
		-p $(PORT):8080 \
		--link mysql \
		-ti \
		sh19910711/homepage:development

dev/mysql:
	docker run \
		--rm \
		--name mysql \
		--memory 100MB \
		--memory-swap 100MB \
		-e MYSQL_ROOT_PASSWORD=mysql \
		mariadb:10.4.1

dev/search:
	docker run \
		--rm \
		--name search \
		 -e "discovery.type=single-node" \
		docker.elastic.co/elasticsearch/elasticsearch:6.5.4

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
		apache/zeppelin:0.8.0

setup/amazonlinux:
	sudo yum install vim tmux docker
	sudo usermod -a -G docker ec2-user
	sudo service docker restart
