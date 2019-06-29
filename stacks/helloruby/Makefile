.PHONY: build
build:
	docker build -t helloruby ./docker
	docker run --rm -w /rubyapp -v $(PWD):/rubyapp helloruby bundle install -j4
	docker run --rm -w /rubyapp -v $(PWD):/rubyapp helloruby bundle install -j4 --deployment
	mkdir -p lib
	docker run --rm -w /rubyapp -v $(PWD):/rubyapp helloruby cp /usr/lib64/mysql/libmysqlclient.so /rubyapp/lib/
	docker run --rm -w /rubyapp -v $(PWD):/rubyapp helloruby cp /usr/lib64/mysql/libmysqlclient.so.18 /rubyapp/lib/
	docker run --rm -w /rubyapp -v $(PWD):/rubyapp helloruby cp /usr/lib64/mysql/libmysqlclient.so.18.0.0 /rubyapp/lib/
	sudo chown -R ec2-user. .bundle
	sudo chown -R ec2-user. Gemfile.lock
	sudo chown -R ec2-user. vendor
