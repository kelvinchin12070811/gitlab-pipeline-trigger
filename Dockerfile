FROM ruby:3.2-alpine as build
WORKDIR /app
COPY . .
RUN apk update && \
    apk upgrade --update-cache --available && \
    apk add --virtual build-dependencies build-base && \
    apk add openssl && \
    rm -rf /var/cache/apk/*
RUN gem install bundler rake && \
    rake bundle_env_prod && \
    bundle install

FROM ruby:3.2-alpine as deploy
WORKDIR /app
COPY --from=build /app .
COPY --from=build /usr/local/bundle/config /usr/local/bundle/config
ENV PORT=80
EXPOSE 80
CMD ["rake", "start"]
