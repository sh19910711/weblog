usage:
	echo make dev

image:
	docker build -t sh19910711/homepage .
	docker build -t sh19910711/homepage:0.0.5 .
	docker push sh19910711/homepage:0.0.5

prod:
	docker run \
		--rm \
		--name homepage \
		-e AWS_REGION=us-east-1 \
		-e RACK_ENV=production \
		-e S3_BUCKET=cloud9-tmp \
		-e S3_PREFIX=homepage/ \
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
		-e S3_BUCKET=cloud9-tmp \
		-e S3_PREFIX=homepage/ \
		-v $(HOME)/.aws:/root/.aws \
		-v $(PWD):/wrk \
		-p $(PORT):8080 \
		-ti \
		sh19910711/homepage:development
