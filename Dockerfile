# FROM node:20.16.0-slim AS build
# WORKDIR /app

# # dependencies pahle copy karo (layer caching ke liye)
# COPY package*.json ./
# RUN npm ci


# # baad mein source code copy karo
# COPY . .
# RUN npm run build
 
# # ---Production stage---
# FROM nginx:stable-alpine
# WORKDIR /usr/share/nginx/html

# # Purana default conrent remove karo
# RUN rm -rf ./*

# COPY --from=build /app/build .

# EXPOSE 80
# cmd ["nginx", "-g", "daemon off;"]



# ❌ Outdated base image (vulnerable)
FROM node:14 AS build

WORKDIR /app

# ❌ unnecessary packages (increase attack surface)
RUN apt-get update && apt-get install -y \
    curl \
    vim \
    telnet \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

# dependencies copy
COPY package*.json ./

# ❌ insecure install (no lockfile enforcement)
RUN npm install

# source code copy
COPY . .

# ❌ hardcoded secrets (Trivy secret scan pakdega)
ENV AWS_SECRET_ACCESS_KEY=1234567890abcdef
ENV DB_PASSWORD=supersecret

# ❌ overly permissive permissions
# RUN chmod -R 777 /app

# build (ensure ye fail na ho)
RUN npm run build || echo "build skipped"


# --- Production stage ---
# ❌ outdated nginx version (more CVEs)
FROM nginx:1.19-alpine

WORKDIR /usr/share/nginx/html

# default content remove
RUN rm -rf ./*

# build output copy
COPY --from=build /app/build .

# ❌ extra tools install (attack surface)
RUN apk add --no-cache bash curl

# ❌ unnecessary ports
EXPOSE 80
EXPOSE 22
EXPOSE 443

# ❌ run as root (default)
# ❌ no security hardening

CMD ["nginx", "-g", "daemon off;"]
