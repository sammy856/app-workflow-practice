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
FROM node:14.17.0 AS build

WORKDIR /app

# dependencies copy
COPY package*.json ./

# ❌ insecure install (no lockfile enforcement)
RUN npm install --legacy-peer-deps

# source code copy
COPY . .
RUN npm run build

FROM nginx:1.14.0

WORKDIR /usr/share/nginx/html

RUN rm -rf ./*

COPY --from=build /app/build .

EXPOSE 80


CMD ["nginx", "-g", "daemon off;"]
