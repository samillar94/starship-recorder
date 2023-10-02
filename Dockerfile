FROM node:alpine

WORKDIR /app

COPY prisma ./prisma/
COPY .env-Docker ./.env
COPY index.ts ./
COPY package*.json ./
COPY tsconfig.json ./

RUN npm install
RUN npx prisma generate

EXPOSE 3000

CMD npm run start

# Sources
# https://www.section.io/engineering-education/dockerized-prisma-postgres-api/#create-and-run-a-prisma-server-with-docker
# https://notiz.dev/blog/prisma-migrate-deploy-with-docker