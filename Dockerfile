# syntax=docker/dockerfile:1.3
FROM node:20 AS builder
WORKDIR /app

# Copy package.json and lockfile to leverage caching
COPY package.json package-lock.json ./
RUN npm install

# Copy source files
COPY . .

# Force node-gyp rebuild (which will use your binding.gyp)
RUN npm run compile

# Export stage: only include the build directory
FROM scratch AS export-stage
# Copy /app/build from the builder stage to /build in the export stage
COPY --from=builder /app/build/Release/*.node /
