# Set Ruby version for the container
ARG RUBY_VERSION=4.0.1
FROM ruby:$RUBY_VERSION-slim

# Set Ruby environment variables
ARG BUNDLE_PATH=/usr/local/bundle
ARG BUNDLER_VERSION=4.0.4
ARG RACK_ENV=production
ARG BUNDLE_WITHOUT="development:test"
ARG PORT=9292 # rackup default

# Install system dependencies
RUN apt-get update -y \
  && apt-get install -y --no-install-recommends \
  ca-certificates \
  build-essential \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  /usr/share/doc \
  /usr/share/man \
  /var/cache/apt/archives

# Set working directory
WORKDIR /app

# Set app environment variables
ENV RACK_ENV=${RACK_ENV} \
  BUNDLE_PATH=${BUNDLE_PATH} \
  BUNDLE_WITHOUT=${BUNDLE_WITHOUT}

# Install app dependencies
RUN gem install bundler:$BUNDLER_VERSION
COPY .ruby-version Gemfile Gemfile.lock ./
RUN bundle install \
  && rm -rf "${BUNDLE_PATH}"/ruby/*/cache \
  "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# Copy the rest of the application
COPY . .

# Expose app TCP port
EXPOSE $PORT

# Run Sinatra Rack app, intentionally overrideable from the command line
# CMD ["bundle", "exec", "rackup", "-o", "0.0.0.0"]
CMD ["bundle", "exec", "rackup"]
