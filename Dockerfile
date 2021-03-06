FROM ruby:2.6.5
RUN apt-get update -qq && apt-get install -y nodejs
WORKDIR /matheus-sales
COPY Gemfile /matheus-sales/Gemfile
COPY Gemfile.lock /matheus-sales/Gemfile.lock
RUN gem install bundler
RUN bundle install
COPY . /matheus-sales

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]