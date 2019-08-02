FROM node:8 AS build

ARG CONF_SWITCH
ENV CONF_SWITCH ${CONF_SWITCH:-build-official-prod}
WORKDIR /app
COPY . ./
RUN yarn install
RUN ./node_modules/.bin/gulp ${CONF_SWITCH}

FROM nginx:stable-alpine
RUN rm -rf /etc/nginx/conf.d/*
COPY --from=build /app/etc/nginx /etc/nginx/conf.d
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
