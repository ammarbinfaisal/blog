FROM ruby:3.2 AS build
WORKDIR /site
COPY Gemfile* ./
RUN bundle config set --local path vendor/bundle && bundle install --jobs 4
COPY . .
# Some Jekyll plugins (jekyll-github-metadata, last-modified-at, etc.) shell out to git.
# Initialize a minimal repo so they do not abort.
RUN git init -q && git config user.email a@a && git config user.name a && git add -A && git commit -q -m b
RUN bundle exec jekyll build -d /site/_site

FROM nginx:alpine
COPY --from=build /site/_site /usr/share/nginx/html
EXPOSE 80
