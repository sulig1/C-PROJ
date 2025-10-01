FROM node:23-alpine AS builder
WORKDIR /app
COPY package.json yarn.lock ./
RUN npm install -g projen
RUN yarn install --frozen-lockfile
COPY . .
RUN yarn build
FROM node:23-alpine
WORKDIR /app
RUN yarn global add serve
COPY --from=builder /app/build ./build
EXPOSE 3000
CMD ["serve", "-s", "build"]
