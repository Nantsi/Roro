# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.4.10
FROM ruby:${RUBY_VERSION}-slim AS base

WORKDIR /rails

ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=development \
    LD_PRELOAD=/usr/local/lib/libjemalloc.so

# Runtime packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      curl \
      libjemalloc2 \
      libvips \
      sqlite3 && \
    ln -s /usr/lib/$(uname -m)-linux-gnu/libjemalloc.so.2 /usr/local/lib/libjemalloc.so && \
    rm -rf /var/lib/apt/lists/*

# ----------------------------------------------------
# Build stage
# ----------------------------------------------------

FROM base AS build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      git \
      libyaml-dev \
      pkg-config \
      nodejs \
      npm && \
    npm install -g yarn && \
    rm -rf /var/lib/apt/lists/*

# Ruby dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle \
      "${BUNDLE_PATH}"/ruby/*/cache \
      "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# JavaScript dependencies
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Copy application
COPY . .

# Make Linux bin files executable
RUN chmod +x bin/* && \
    sed -i 's/\r$//g' bin/* && \
    sed -i 's/ruby\.exe$/ruby/' bin/*

# Bootsnap
RUN bundle exec bootsnap precompile -j 1 --gemfile
RUN bundle exec bootsnap precompile -j 1 app/ lib/

# Compile Bootstrap CSS
RUN yarn build:css

# Compile Rails assets
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# ----------------------------------------------------
# Runtime image
# ----------------------------------------------------

FROM base

RUN groupadd --system --gid 1000 rails && \
    useradd --system --uid 1000 --gid 1000 --create-home rails

USER rails

COPY --from=build --chown=rails:rails /usr/local/bundle /usr/local/bundle
COPY --from=build --chown=rails:rails /rails /rails

ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 80

CMD ["./bin/thrust", "./bin/rails", "server"]