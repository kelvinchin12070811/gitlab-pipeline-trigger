FROM ruby:3.2-alpine as build
WORKDIR /app
COPY . .
RUN ruby ./build.rb

FROM ruby:3.2-alpine as deploy
WORKDIR /app
COPY --from=build /app/ .
ENV PORT=80
EXPOSE 80
CMD ["rake", "start"]
