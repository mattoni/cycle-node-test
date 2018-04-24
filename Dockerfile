FROM node:alpine AS compiler
WORKDIR /build
RUN apk update && apk upgrade && apk add --no-cache bash openssh
ADD package.json .
RUN npm install
COPY . .
RUN npm run build

FROM node:alpine
WORKDIR /dist
COPY package.json .
COPY --from=compiler /build/dist .
RUN npm install --production
EXPOSE 80
CMD ["node", "dist"]