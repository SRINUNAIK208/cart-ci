FROM node:22-alpine3.23 AS builder 
WORKDIR /app 
COPY package.json .
RUN npm install 
COPY *.js . 

FROM node:22-alpine3.23
WORKDIR /app
RUN addgroup -S roboshop && adduser -S roboshop -G roboshop
ENV REDIS_HOST="redis" \
    CATALOGUE_HOST="catalogue" \
    CATALOGUE_PORT="8080"
COPY --from=builder /app .
USER roboshop
CMD ["node", "server.js"]