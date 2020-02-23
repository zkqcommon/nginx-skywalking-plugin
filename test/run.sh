#!/usr/bin/env bash

openresty -p `pwd`/ -c `pwd`/nginx.conf -s stop
>`pwd`/logs/error.log
>`pwd`/logs/access.log

openresty -p `pwd`/ -c `pwd`/nginx.conf