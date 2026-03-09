#!/usr/bin/env sh
set -e

# create .env from example
[ -f .env.example ] && [ ! -f .env ] && cp .env.example .env && echo ".env created"

# install deps (use npm ci if lockfile and CI-style)
if [ -f package-lock.json ]; then
  npm ci
else
  npm install
fi

# optional Prisma steps only if present
[ -f prisma/schema.prisma ] && npx prisma generate || true
[ -d prisma/migrations ] && npx prisma migrate deploy || true
[ -f prisma/seed.js ] && node prisma/seed.js || true

echo "Setup complete."
