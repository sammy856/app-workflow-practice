FROM node:20.16.0-slim AS build
WORKDIR /app
COPY . .
RUN apt update -y && apt upgrade -y
RUN npm install && npm run build
 
FROM nginx:stable-alpine
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80