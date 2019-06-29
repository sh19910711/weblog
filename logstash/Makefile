VERSION=0.0.0
IMAGE=sh19910711/homepage-logstash

.PHONY: build
build:
	docker build -t $(IMAGE) .
	docker tag $(IMAGE) $(IMAGE):$(VERSION)
	docker push $(IMAGE):$(VERSION)
