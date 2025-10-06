FROM node:20-alpine AS builder
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile
COPY . .
RUN yarn build
FROM nginx:alpine
WORKDIR /app
RUN adduser -D appuser
COPY --from=builder /app/build /usr/share/nginx/html
RUN chown -R appuser:appuser /usr/share/nginx/html
USER appuser
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
