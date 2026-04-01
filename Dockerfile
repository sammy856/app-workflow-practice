FROM node:20.16.0-slim AS build
WORKDIR /app

# dependencies pahle copy karo (layer caching ke liye)
COPY package*.json ./
RUN npm ci


# baad mein source code copy karo
COPY . .
RUN npm run build
 
# ---Production stage---
FROM nginx:stable-alpine
WORKDIR /usr/share/nginx/html

# Purana default conrent remove karo
RUN rm -rf ./*

COPY --from=build /app/build .

EXPOSE 80
cmd ["nginx", "-g", "daemon off;"]

