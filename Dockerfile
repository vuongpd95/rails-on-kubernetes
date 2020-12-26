FROM ruby:2.7.2

LABEL MAINTAINER=vuongpd95@gmail.com

ENV RAILS_ENV=production

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./

RUN bundle install

ENV CACHE_BURST=1

COPY . .

# RUN bundle exec rails assets:precompile

# CMD ["bundle", "exec", "rails", "server", "-u", "puma", "-p", "3000"]
