FROM ruby:3.4.4
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs postgresql-client -y iputils-ping
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . .
EXPOSE 2300
CMD ["bundle", "exec", "hanami", "server", "--host", "0.0.0.0"]
