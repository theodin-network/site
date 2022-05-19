# The Odin Things Network Page



## The nginx configuation

**/etc/nginx/sites-enabled/theodin_network.conf**

```
#----------------------------------------------------------------------
# theodin.network
#----------------------------------------------------------------------

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name theodin.network;
    server_name www.theodin.network;
    root /var/www/theodin.network;
    error_log off;

    add_header Content-Security-Policy "default-src 'self'; script-src 'self' ajax.cloudflare.com static.cloudflareinsights.com maxcdn.bootstrapcdn.com code.jquery.com; style-src 'self' stackpath.bootstrapcdn.com; img-src 'self'; font-src 'self' data: use.fontawesome.com fonts.googleapis.com";
    add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload";
    add_header Referrer-Policy no-referrer;
    add_header Content-Security-Policy "frame-ancestors 'none'";
    add_header Feature "Policy ON";
    add_header X-Frame-Options SAMEORIGIN;
    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection "1; mode=block";

    ssl_certificate         /etc/nginx/certs/cloudflare-theodin_network.cert.pem;
    ssl_certificate_key     /etc/nginx/certs/cloudflare-theodin_network.priviate.pem;
    ssl_client_certificate  /etc/nginx/certs/origin-pull-ca.pem;
    ssl_verify_client on;

    error_page 404 /404/index.html;

    location ~* /(.git|.gitignore|LICENSE|README.md) {
        return 404;
    }

    location ~* \.(html|jpg|ico|css|js|woff2)$ {
        expires 90d;
        add_header Cache-Control "public, no-transform";
    }

    location ^~ /.well-known/openpgpkey/ {
        default_type        "text/plain";
        add_header          'Access-Control-Allow-Origin' '*' always;
    }

    location /keys {
        expires             7d;
        default_type        "text/plain";
        add_header          Content-Type text/plain;
    }
}
```

# License

    MIT License

    Copyright (c) 2021 Matt Rude

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE
