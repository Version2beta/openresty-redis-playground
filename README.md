# Playing with OpenResty

This repository is just a playground for figuring out my OpenResty dev environment.

## OpenResty installation (OS X Mavericks)

`brew install luarocks` - because Lua rocks. (Not my general opinion, but it's growing on me.)

`brew install pcre` - needed for openresty.

OpenResty's `./configure` step needs to know where the pcre code lives, so run this command to make sure that command is right: `mdfind pcre | grep usr/local`.

`brew install redis` - because it's my playground and I'm bringing the toys.

Install OpenResty:

```
curl -OL http://openresty.org/download/ngx_openresty-1.5.11.1.tar.gz
tar xvzf ngx_openresty-1.5.11.1.tar.gz
cd ngx_openresty-1.5.11.1
./configure --with-luajit --with-cc-opt="-I/usr/local/Cellar/pcre/8.35/include" --with-ld-opt="-L/usr/local/Cellar/pcre/8.35/lib"
make
make install
ln -s /usr/local/openresty/nginx/sbin/nginx /usr/local/bin/openresty
```

### Optional stuff

`luarocks install moonscript` - haven't tried it yet.

`luarocks install lapis` - haven't tried it yet either.

## Running

`launchctl start homebrew.mxcl.redis` - Make sure Redis is running, just in case it's stopped.

From the top directory of the repository, start OpenResty and the test runner: `shoreman`.
