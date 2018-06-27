stack:
	mkdir -p tmp

	aws cloudformation package \
		--template-file cluster.yml \
		--s3-bucket cloud9-tmp \
		--s3-prefix cloudformation/homepage \
		--output-template-file tmp/packaged-template.yml

	aws cloudformation deploy \
		--template-file tmp/packaged-template.yml \
		--stack-name homepage \
		--capabilities CAPABILITY_IAM
