FROM multi/nginx

COPY app.conf /etc/nginx/conf.d/app.conf

EXPOSE 8080
