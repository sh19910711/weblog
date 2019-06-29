.PHONY: build
build:
	npm install amazon-cognito-identity-js
	mkdir -p dist
	cp node_modules/amazon-cognito-identity-js/dist/amazon-cognito-identity.min.js ./dist/
	aws s3 cp edit.html s3://static.sano.ninja/html/edit/
	aws s3 cp --recursive dist s3://static.sano.ninja/html/edit/dist/
