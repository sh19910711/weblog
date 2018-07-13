usage:
	echo make dev

image:
	docker build -t sh19910711/homepage .
	docker build -t sh19910711/homepage:0.0.5 .
	docker push sh19910711/homepage:0.0.5

prod:
	docker run \
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
	docker run \
		-e AWS_REGION=us-east-1 \
		-e RACK_ENV=development \
		-e S3_BUCKET=cloud9-tmp \
		-e S3_PREFIX=homepage/ \
		-v $(HOME)/.aws:/root/.aws \
		-v $(PWD):/wrk \
		-p 8080:8080 \
		-ti \
		sh19910711/homepage \
		ash -c "bundle install -j4 --with development && bundle exec rackup \
			--host 0.0.0.0 \
			--port 8080 \
			./config.development.ru"
