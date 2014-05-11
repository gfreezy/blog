---
layout: post
title: uwsgi与nginx的多站点配置
tags: 技术 uwsgi nginx
---
**From [uWSGI Examples](http://projects.unbit.it/uwsgi/wiki/Example)**

We have two virtualenv, DJANGOVENVS/pinax1 and DJANGOVENVS/pinax2.

Each virtualenv contains a pinax site in the directory 'pinaxsite' and a script (called pinax.py) in every pinaxsite/deploy directory (that is a copy of deploy/pinax.wsgi)

Now configure nginx

    server {
         listen       8080;
         server_name  sirius.local;

         location / {
                 include uwsgi_params;
                 uwsgi_pass 127.0.0.1:3031;
                 uwsgi_param UWSGI_PYHOME /Users/roberto/DJANGOVENVS/pinax1;
                 uwsgi_param UWSGI_SCRIPT deploy.pinax;
                 uwsgi_param UWSGI_CHDIR /Users/roberto/DJANGOVENVS/pinax1/pinaxsite;
        }
    }

    server {
        listen       8080;
        server_name  localhost;

        location / {
                include uwsgi_params;
                uwsgi_pass 127.0.0.1:3031;
                uwsgi_param UWSGI_PYHOME /Users/roberto/DJANGOVENVS/pinax2;
                uwsgi_param UWSGI_SCRIPT deploy.pinax;
                uwsgi_param UWSGI_CHDIR /Users/roberto/DJANGOVENVS/pinax2/pinaxsite;
        }
    }


and run uWSGI in VirtualHosting mode

    ./uwsgi -s :3031 -M -p 10 --vhost --no-site
