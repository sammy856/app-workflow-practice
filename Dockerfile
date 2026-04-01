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



# ❌ Outdated + vulnerable base image
FROM node:12

WORKDIR /app

# ❌ Install unnecessary + vulnerable packages
RUN apt-get update && apt-get install -y \
    curl \
    vim \
    telnet \
    net-tools \
    ftp \
    && rm -rf /var/lib/apt/lists/*

# ❌ Copy everything (including secrets if present)
COPY . .

# ❌ Insecure dependency install
RUN npm install

# ❌ Add fake secret (Trivy secret scan pakdega)
ENV AWS_SECRET_ACCESS_KEY=1234567890abcdef
ENV DB_PASSWORD=supersecret

# ❌ Open unnecessary ports
EXPOSE 80
EXPOSE 22
EXPOSE 3000

# ❌ Run as root (default)
# ❌ Use dev server in production
CMD ["npm", "start"]
