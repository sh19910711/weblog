FROM ruby:2.6.5-alpine

RUN bundle --version
ADD ./Gemfile /tmp
ADD ./Gemfile.lock /tmp
WORKDIR /tmp
RUN apk update && \
  apk add \
    build-base \
    libffi-dev \
    mysql-dev && \
  /usr/local/bin/bundle install -j4 --without development

RUN mkdir /wrk
ADD ./ /wrk
WORKDIR /wrk

ENV RACK_ENV=production
EXPOSE 8080
CMD bundle exec rackup --host 0.0.0.0 --port 8080
