# Build stage
FROM node:22-alpine AS build_image

WORKDIR /usr/src/app

COPY package.json ./

RUN yarn install

COPY . .

RUN yarn build

RUN yarn install --production && yarn cache clean


# Runtime stage
FROM node:22-alpine

WORKDIR /usr/src/app

COPY --from=build_image /usr/src/app/package.json ./
COPY --from=build_image /usr/src/app/node_modules ./node_modules
COPY --from=build_image /usr/src/app/.next ./.next
COPY --from=build_image /usr/src/app/public ./public

EXPOSE 3000

CMD ["yarn", "start"]