#!/usr/bin/env bash

openresty -p `pwd`/ -c `pwd`/nginx-test.conf -s stop
>`pwd`/logs/error.log
>`pwd`/logs/access.log
>`pwd`/logs/debug.log

openresty -p `pwd`/ -c `pwd`/nginx-test.conf