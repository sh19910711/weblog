usage:
	echo make development

stacks/development:
	aws cloudformation package \
		--template-file stacks/development.yml \
		--s3-bucket cloud9-tmp \
		--s3-prefix homepage/development/cloudformation \
		--output-template-file /tmp/packaged-cloudformation.yml

	aws cloudformation deploy \
		--template-file /tmp/packaged-cloudformation.yml \
		--stack-name weblog-development \
		--capabilities CAPABILITY_IAM

build:
	docker build -t sh19910711/homepage .

prod:
	docker run \
		-e S3_BUCKET=cloud9-tmp \
		-e S3_PREFIX=homepage/ \
		-v $(HOME)/.aws:/root/.aws \
		-v $(PWD):/wrk \
		-p 8080:8080 \
		-ti \
		sh19910711/homepage

dev:
	docker run \
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
