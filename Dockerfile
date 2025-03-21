# Use official Elixir image
FROM elixir:1.15-alpine

# Install build tools + hex + rebar
RUN apk add --no-cache build-base git && \
    mix local.hex --force && \
    mix local.rebar --force

# Set working directory inside container
WORKDIR /app

# Copy mix files and fetch deps
COPY mix.exs mix.lock ./
COPY config ./config
RUN mix deps.get --only prod

# Copy the rest of the code
COPY . .

# Compile the project
RUN MIX_ENV=prod mix compile

# Expose the port
EXPOSE 4000

# Start the app
CMD ["mix", "run", "--no-halt"]
