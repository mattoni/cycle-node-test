FROM node:alpine AS compiler
WORKDIR /app
RUN apk update && apk upgrade
ADD package.json .
RUN npm install
COPY . .
RUN npm run build

FROM node:alpine
WORKDIR /app
COPY package.json .
COPY --from=compiler /app/build ./build
COPY --from=compiler /app/server ./server
RUN npm install --production
EXPOSE 80
CMD ["node", "server/index.js"]