# Use an official lightweight Node.js image as the base
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Install required system dependencies
RUN apk add --no-cache openssl curl bash

# Copy package.json and lock files separately (for caching optimization)
COPY package.json package-lock.json* yarn.lock* ./

# Install dependencies
RUN npm install --frozen-lockfile

# Copy the full project
COPY . .

# Generate Prisma client (ensures Prisma works inside Docker)
RUN npx prisma generate

# Build the Next.js application
RUN npm run build

# Use a lightweight Node.js image for the final production stage
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Install required system dependencies
RUN apk add --no-cache openssl curl bash

# Copy built files and dependencies from the builder stage
COPY --from=builder /app ./

# Expose the port Next.js runs on
EXPOSE 3000

# Run Prisma migrations in production before starting the app
CMD ["sh", "-c", "npx prisma migrate deploy && npm run start"]
