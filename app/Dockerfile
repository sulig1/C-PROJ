FROM node:20-alpine AS builder
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile
COPY . .
RUN yarn build
FROM nginx:alpine
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
COPY nginx.conf /etc/nginx/conf.d/default.conf
RUN mkdir -p /var/cache/nginx /var/run /var/log/nginx && \
    chown -R appuser:appgroup /var/cache/nginx /var/run /var/log/nginx /usr/share/nginx/html
COPY --from=builder /app/build /usr/share/nginx/html
USER appuser
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
