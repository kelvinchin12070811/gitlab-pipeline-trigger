FROM ruby:3.2-alpine
WORKDIR /app
COPY . .
RUN apk update && \
    apk upgrade --update-cache --available && \
    apk add --virtual build-dependencies build-base && \
    apk add openssl && \
    rm -rf /var/cache/apk/*
RUN gem install bundler rake && \
    gem install ffi -- --disable-system-libffi && \
    bundle config set --local without dev && \
    bundle install
ENV PORT=80
EXPOSE 80
CMD ["rake", "start"]
