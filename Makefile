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
