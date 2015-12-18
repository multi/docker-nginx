FROM multi/nginx:1.8.0

COPY app.conf /etc/nginx/conf.d/app.conf

EXPOSE 8080
