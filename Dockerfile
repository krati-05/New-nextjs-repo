FROM node:22.21.0-alpine AS build_image
 
WORKDIR /usr/src/app
 
COPY package*.json ./
 
RUN yarn install
 
COPY . .
RUN yarn build
# remove dev dependencies
RUN yarn install --production
 
FROM node:22.21.0-alpine
WORKDIR /usr/src/app
COPY --from=build_image /usr/src/app/package.json ./package.json
COPY --from=build_image /usr/src/app/node_modules ./node_modules
COPY --from=build_image /usr/src/app/.next  ./.next
COPY --from=build_image /usr/src/app/dist  ./dist
COPY --from=build_image /usr/src/app/public ./public
 
EXPOSE 3000
CMD ["yarn", "start"]