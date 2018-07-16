usage:
	echo make dev

image:
	docker build -t sh19910711/homepage .
	docker build -t sh19910711/homepage:0.0.8 .
	docker push sh19910711/homepage:0.0.8

prod:
	docker run \
		--rm \
		--name homepage \
		-e AWS_REGION=us-east-1 \
		-e RACK_ENV=production \
		-e S3_BUCKET=hiroyuki.sano.ninja \
		-e S3_PREFIX=zeppelin/ \
		-v $(HOME)/.aws:/root/.aws \
		-v $(PWD):/wrk \
		-p 8080:8080 \
		-ti \
		sh19910711/homepage

dev:
	docker build -t sh19910711/homepage:development -f Dockerfile.dev .
	docker run \
		--rm \
		--name homepage \
		-e AWS_REGION=us-east-1 \
		-e RACK_ENV=development \
		-e S3_BUCKET=hiroyuki.sano.ninja \
		-e S3_PREFIX=zeppelin/ \
		-v $(HOME)/.aws:/root/.aws \
		-v $(PWD):/wrk \
		-p $(PORT):8080 \
		-ti \
		sh19910711/homepage:development

.PHONY: spec
spec:
	docker exec homepage bundle exec rspec
