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

CMD npm run migrate:start:studio