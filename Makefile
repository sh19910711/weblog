VERSION=0.2

.PHONY: build
build:
	docker build -t sh19910711/homepage ./docker/webapp
	docker tag sh19910711/homepage sh19910711/homepage:$(VERSION)

	docker build -t sh19910711/homepage_search ./docker/search
	docker tag sh19910711/homepage_search sh19910711/homepage_search:$(VERSION)

.PHONY: push
push: build
	docker push sh19910711/homepage:$(VERSION)
	docker push sh19910711/homepage_search:$(VERSION)
	docker push sh19910711/homepage_commands:$(VERSION)

/usr/local/bin/docker-compose:
	sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(shell uname -s)-$(shell uname -m)" -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
	docker-compose --version

.PHONY: dev
dev: /usr/local/bin/docker-compose
	docker-compose up -d

.PHONY: setup/amazonlinux
setup/amazonlinux:
	sudo yum install vim tmux docker
	sudo usermod -a -G docker ec2-user
	sudo service docker restart
