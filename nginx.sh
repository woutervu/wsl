#!/bin/bash
echo "> Installing Nginx..."
sudo apt-get install nginx -y

echo "Setting up PHP Fpm"
sudo touch /etc/nginx/phpfpm
echo "listen 80;
  location ~ \.php$ {
    include snippets/fastcgi-php.conf;
  #
  # # With php-fpm (or other unix sockets):
    fastcgi_pass unix:/var/run/php/php7.1-fpm.sock;
fastcgi_param  QUERY_STRING       $query_string;
fastcgi_param  REQUEST_METHOD     $request_method;
fastcgi_param  CONTENT_TYPE       $content_type;
fastcgi_param  CONTENT_LENGTH     $content_length;
fastcgi_param  SCRIPT_NAME        $fastcgi_script_name;
fastcgi_param  REQUEST_URI        $request_uri;
fastcgi_param  DOCUMENT_URI       $document_uri;
fastcgi_param  DOCUMENT_ROOT      $document_root;
fastcgi_param  SERVER_PROTOCOL    $server_protocol;
fastcgi_param  REQUEST_SCHEME     $scheme;
fastcgi_param  HTTPS              $https if_not_empty;
fastcgi_param  GATEWAY_INTERFACE  CGI/1.1;
fastcgi_param  SERVER_SOFTWARE    nginx/$nginx_version;
fastcgi_param  REMOTE_ADDR        $remote_addr;
fastcgi_param  REMOTE_PORT        $remote_port;
fastcgi_param  SERVER_ADDR        $server_addr;
fastcgi_param  SERVER_PORT        $server_port;
fastcgi_param  SERVER_NAME        $server_name;
# PHP only, required if PHP was built with --enable-force-cgi-redirect
fastcgi_param  REDIRECT_STATUS    200;
fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    fastcgi_intercept_errors on;
  }" | sudo tee /etc/nginx/phpfpm

# Prompt for default drupal 8 site config
read -p "Copy default drupal 8 nginx site config?" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
sudo touch /etc/nginx/sites-available/ddrupal8
echo "server {
  server_name mydrupal8site.dev;
  root /path/to/drupal8/htdocs;
  index index.php;

  location / {
        # This is cool because no php is touched for static content
        try_files $uri @rewrite;
    }

    location @rewrite {
        # Some modules enforce no slash (/) at the end of the URL
        # Else this rewrite block wouldn't be needed (GlobalRedirect)
        rewrite ^ /index.php;
    }

    access_log off;
    error_log  /var/log/nginx/mydrupal8site-error.log error;

  include phpfpm;
}" | sudo tee /etc/nginx/sites-available/ddrupal8
fi

echo "> Adding Nginx to ~/upstart.sh"
echo "service nginx stop " >> ~/upstart.sh
echo "service nginx start " >> ~/upstart.sh
