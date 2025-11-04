# --- BUILD STAGE ---
# Use a full Elixir image for building and compiling.
FROM hexpm/elixir:1.15.7-erlang-26.2.2-alpine-3.18.5 as builder
# Set production environment
ENV MIX_ENV=prod
WORKDIR /app

# Install build dependencies
RUN apk add --no-cache git build-base python3 npm

# Copy and install dependencies
COPY mix.exs mix.lock ./
COPY config config/
RUN mix do deps.get, deps.compile

# Compile assets (if using Phoenix static assets)
COPY assets assets/
RUN npm install --prefix ./assets
RUN mix phx.digest

# Compile and create release
COPY lib lib/
RUN mix compile
RUN mix release

# --- RELEASE STAGE ---
# Use a minimal Alpine image for a small, secure runtime.
FROM alpine:3.18.5 as release
# Install necessary runtime dependencies (e.g., openssl for Elixir/Erlang, postgres client for migration/runtime checks)
RUN apk add --no-cache openssl bash postgresql-client
WORKDIR /app

# Copy the pre-built release artifact from the builder stage
COPY --from=builder /app/_build/prod/rel/your_app_name/ .

# Ensure the app starts with runtime configuration (e.g., using config/runtime.exs)
# Your Elixir release needs to be configured to read environment variables at runtime.
CMD ["/app/bin/server"]
