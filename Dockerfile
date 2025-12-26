FROM ruby:3.4.8-slim

ENV RACK_ENV=production \
  BUNDLE_WITHOUT="development:test" \
  BUNDLE_DEPLOYMENT=1 \
  BUNDLE_PATH=/usr/local/bundle \
  PORT=3000

WORKDIR /app

# minimal OS deps
RUN apt-get update -y && apt-get install -y --no-install-recommends \
  ca-certificates \
  build-essential \
  curl \
  && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 3000

HEALTHCHECK --interval=5s --timeout=2s --start-period=10s --retries=12 \
  CMD curl -fsS http://127.0.0.1:3000/healthz || exit 1

# run Rack/Sinatra app
CMD ["bundle", "exec", "rackup", "-o", "0.0.0.0", "-p", "3000"]
