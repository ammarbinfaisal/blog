FROM ruby:3.2 AS build
WORKDIR /site
COPY Gemfile* ./
RUN bundle config set --local path vendor/bundle && bundle install --jobs 4
COPY . .
RUN bundle exec jekyll build -d /site/_site

FROM nginx:alpine
COPY --from=build /site/_site /usr/share/nginx/html
EXPOSE 80
