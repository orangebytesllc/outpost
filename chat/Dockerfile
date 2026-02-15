# syntax=docker/dockerfile:1
# check=error=true

# Outpost Docker Image
# 
# This Dockerfile builds a production-ready, self-contained image that includes:
# - Rails application with Puma web server
# - Thruster for HTTP/2, SSL (via Let's Encrypt), and asset compression
# - SolidQueue for background job processing
#
# Quick start:
#   docker build -t outpost .
#   docker run -d -p 80:80 -p 443:443 \
#     -e SECRET_KEY_BASE=$(openssl rand -hex 64) \
#     -e TLS_DOMAIN=chat.example.com \
#     -v outpost_storage:/rails/storage \
#     outpost
#
# Environment variables:
#   SECRET_KEY_BASE  - Required. Rails secret key (generate with: openssl rand -hex 64)
#   TLS_DOMAIN       - Domain for automatic SSL via Let's Encrypt
#   DISABLE_SSL      - Set to skip SSL (for reverse proxy or internal use)
#
# For a containerized dev environment, see Dev Containers: https://guides.rubyonrails.org/getting_started_with_devcontainer.html

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.4.1
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /rails

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips sqlite3 && \
    ln -s /usr/lib/$(uname -m)-linux-gnu/libjemalloc.so.2 /usr/local/lib/libjemalloc.so && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set production environment variables and enable jemalloc for reduced memory usage and latency.
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development" \
    LD_PRELOAD="/usr/local/lib/libjemalloc.so"

# Throw-away build stage to reduce size of final image
FROM base AS build

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libyaml-dev pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install application gems
COPY vendor/* ./vendor/
COPY Gemfile Gemfile.lock ./

RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    # -j 1 disable parallel compilation to avoid a QEMU bug: https://github.com/rails/bootsnap/issues/495
    bundle exec bootsnap precompile -j 1 --gemfile

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times.
# -j 1 disable parallel compilation to avoid a QEMU bug: https://github.com/rails/bootsnap/issues/495
RUN bundle exec bootsnap precompile -j 1 app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile




# Final stage for app image
FROM base

# Image metadata
LABEL org.opencontainers.image.source="https://github.com/orangebytes/outpost"
LABEL org.opencontainers.image.description="Outpost - Self-hosted team chat"
LABEL org.opencontainers.image.licenses="MIT"

# Build arguments for versioning
ARG APP_VERSION
ARG GIT_REVISION

# Run and own only the runtime files as a non-root user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    mkdir -p /rails/storage && \
    chown -R rails:rails /rails/storage

USER 1000:1000

# Copy built artifacts: gems, application
COPY --chown=rails:rails --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --chown=rails:rails --from=build /rails /rails

# Set version info
ENV APP_VERSION=${APP_VERSION}
ENV GIT_REVISION=${GIT_REVISION}

# Entrypoint runs setup and prepares the application
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Expose HTTP and HTTPS ports
EXPOSE 80 443

# Start all processes via the boot script
CMD ["./bin/boot"]
