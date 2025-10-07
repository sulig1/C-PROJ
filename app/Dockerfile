FROM node:20-alpine AS builder
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile
COPY . .
RUN yarn build
FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
WORKDIR /app
COPY --from=builder /app/build /usr/share/nginx/html
RUN chown -R appuser:appgroup /usr/share/nginx/html
USER appuser
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
