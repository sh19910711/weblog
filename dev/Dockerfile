FROM sh19910711/homepage

RUN apk update && \
  apk add w3m vim && \
  bundle install -j4 --with development

CMD bundle exec rackup --host 0.0.0.0 --port 8080 ./config.ru
