# syntax=docker/dockerfile:1

# Use the official Ruby image from the Docker Hub
ARG RUBY_VERSION=3.4
FROM ruby:$RUBY_VERSION-slim

# Set the working directory
WORKDIR /app

# Install base packages and PostgreSQL client
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential libpq-dev nodejs postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy the Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy the rest of the application code
COPY . .

# Expose port 3000 to the Docker host
EXPOSE 3000

# Set environment variables
ENV RAILS_ENV=development \
    SECRET_KEY_BASE=dummy

# Start the Rails server
CMD ["bash", "-c", "rm -f tmp/pids/server.pid && bundle exec rails s -b '0.0.0.0'"]