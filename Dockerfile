# ----------
# BASE image
# ----------

# Best practice is to lock in specific version
FROM node:14.15.1-alpine3.10

ENV NODE_PATH /data/node_modules
# Needed for react
ENV PATH /data/node_modules/.bin:$PATH
ENV APP_PATH /data/app

WORKDIR $APP_PATH

# Cache node modules in /data/node_modules
COPY package*.json yarn.lock /data/

RUN cd /data && NODE_ENV=production npm install

COPY . ./
RUN rm -fr node_modules build
RUN npm run build

FROM nginx:1.19.5-alpine

LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.name=frontend
LABEL org.label-schema.description="Test react frontend"

EXPOSE 80

COPY --from=0 /data/app/build /usr/share/nginx/html
