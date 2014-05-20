# Playing with OpenResty

This repository is a playground for figuring out my OpenResty dev environment.

It can be used as a starting point for a new OpenResty project:

* Build your app under the `app/` directory, starting with `app/init.lua`.
* Add any Lua libraries you need to requirements.txt.
* Update this file, README.md.

## OpenResty installation (OS X Mavericks)

`brew install luarocks` - because Lua rocks. (Not my general opinion, but it's growing on me.)

`brew install pcre` - needed for openresty.

OpenResty's `./configure` step needs to know where the pcre code lives, so run this command to make sure that command is right: `mdfind pcre | grep usr/local`.

`brew install redis` - because it's my playground and I'm bringing the toys.

Install [https://github.com/hecticjeff/shoreman](https://github.com/hecticjeff/shoreman), because it's the Procfile runner I'm using: `brew install --HEAD hecticjeff/formula/shoreman`.

Install [https://bitbucket.org/eradman/entr/](https://bitbucket.org/eradman/entr/), because it triggers the test runner: `brew install entr`.

`xargs luarocks install <requirements.txt` - install the Lua prerequisites.

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

## Credit

My starting point and help along the way came from my [Peer60 Inc.](http://peer60.com) coworker [Jason Staten](https://github.com/statianzo/). Thanks also to participants on the #lua IRC channel who provided feedback and advice.
