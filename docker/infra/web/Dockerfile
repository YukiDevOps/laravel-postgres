FROM nginx:stable-alpine

ENV TZ Asia/Tokyo

COPY ./docker/infra/web/server.conf /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]