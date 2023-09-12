FROM alpine
RUN apk update
RUN apk add curl
RUN apk add openrc --no-cache
RUN printf "%s%s%s%s\n" \
"@nginx " \
"http://nginx.org/packages/alpine/v" \
`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release` \
"/main" \
| tee -a /etc/apk/repositories
RUN curl -o /tmp/nginx_signing.rsa.pub https://nginx.org/keys/nginx_signing.rsa.pub
RUN mv /tmp/nginx_signing.rsa.pub /etc/apk/keys/
RUN apk add nginx@nginx 
EXPOSE 8080:80
WORKDIR /usr/share/nginx/html
COPY ./data/index.html /var/www/html/
ADD default.conf /etc/nginx/conf.d/
CMD ["nginx", "-g", "daemon off;"]