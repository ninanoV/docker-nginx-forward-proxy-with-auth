# docker-nginx-forward-proxy-with-auth
This is docker macvlan-based nginx forward proxy with auth
도커의 macvlan을 이용한 forward proxy 입니다.
nginx의 auth basic을 이용하여 인증을 처리합니다.

Configuration
---------------------

create user example hello:world
```
$ htpasswd -c ./pwd hello 
New password:           <<<<<< input "world"
Re-type new password:     <<<<<<< input "world"
Adding password for user hello
```

users created in this way can copy from Dockerfile
```
COPY ./pwd /tmp/
```

and used in nginx.conf
```
auth_basic_user_file /tmp/pwd;
```

How to use with docker compose
```yaml
version: "3.9"

services:
    proxy_a:
        image: proxyman
        container_name: proxy_a
        ports:
            - "3128:3128"
        networks:
            mymacvlan:
                ipv4_address: A.B.C.D # your ip
        restart: always
        
networks:
    mymacvlan:
        name: mymacvlan
        driver: macvlan
        driver_opts:
            parent: eno1
        ipam:
            config:
                - subnet: "A.B.C.0/24"  # example.
                  gateway: "A.B.C.D"
                - subnet: "E.F.G.0/24"
                  gateway: "E.F.G.H"

```

## Resource
- [chobits/ngx_http_proxy_connect_module](https://github.com/chobits/ngx_http_proxy_connect_module)
