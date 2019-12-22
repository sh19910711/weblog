stack:
	mkdir -p tmp

	aws cloudformation package \
		--template-file cluster.yml \
		--s3-bucket cloud9-tmp \
		--s3-prefix cloudformation/homepage \
		--output-template-file tmp/packaged-template.yml

	aws cloudformation deploy \
		--region us-east-1 \
		--template-file tmp/packaged-template.yml \
		--stack-name homepage \
		--parameter-overrides HomepageVersion=0.1.2 \
		--capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND
