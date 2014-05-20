web: openresty -p `pwd` -c conf/nginx.conf
watcher: find . | entr curl http://localhost:8080/testraw
