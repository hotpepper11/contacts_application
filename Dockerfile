# --- STAGE 1: Builder ---
# Use a minimal Elixir image for building and compiling
FROM hexpm/elixir:1.16.0-erlang-26.2.3-alpine-3.18.5 AS builder

# Install necessary build tools and packages
RUN apk update && apk add --no-cache \
    build-base \
    git \
    npm \
    python3 \
    postgresql-client

# Set the working directory
WORKDIR /app

# Copy application files (mix.exs and mix.lock first for dependency caching)
COPY mix.exs mix.lock ./
# Fetch dependencies (will cache if mix.lock hasn't changed)
RUN mix deps.get --only prod

# Copy the rest of the application code
COPY . .

# Compile static assets (assuming you use Node/NPM for JS/CSS assets)
# This step might require `npm install` and running the Phoenix build task
RUN npm install --prefix assets && npm run deploy --prefix assets

# Compile the Elixir application
RUN mix compile

# Create the release
RUN mix release

# --- STAGE 2: Release ---
# Use a minimal Alpine image for the final runtime environment
FROM alpine:3.18.5 AS release

# Install runner packages
RUN apk update && apk add --no-cache libstdc++ openssl postgresql-client

# Set environment variables for the release
ENV HOME=/app \
    MIX_ENV=prod \
    NODE_ENV=production \
    # Ensure Phoenix connects correctly over the network
    PHX_HOST=0.0.0.0 \
    # The port Phoenix will run on inside the container
    PORT=4000

# Copy the generated release from the builder stage
WORKDIR /app
COPY --from=builder /app/_build/prod/rel/your_app_name ./

# Expose the application port
EXPOSE 4000

# The entrypoint runs the server start script
CMD ["/app/bin/your_app_name", "start"]

