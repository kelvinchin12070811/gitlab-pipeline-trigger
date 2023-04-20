#! /usr/local/bin/ruby
# frozen_string_literal: true

system 'apk update'
system 'apk upgrade --update-cache --available'
system 'apk add --no-cache --virtual .build-deps'
system 'apk add openssl'
system 'rm -rf /var/cache/apk/*'

system 'gem install rake bundle'
system 'gem install ffi -- --disable-system-ffi'
system 'bundle config set --local without dev'
system 'bundle install'
