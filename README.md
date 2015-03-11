
### Usage

Example #1:

```Lua
local cache = ophal.cache
cache:set('var:1', 'This is data for cache var:1.')
```
NOTE: Cache is not an standard module, it registers itself under the global ophal variable.

Example #2:

```Lua
local cache = ophal.cache
cache('custom'):set('var:2', {id = 1, somekey = 'storing this Lua table on a different bin'}, time() + 5*60*60)
```
NOTE: To specify a different cache bin, pass it as argument of cache. Custom expire time is set as 3rd argument.


### Installation

Run the following SQL queries in strict order:

```SQL
-- SQLite3
CREATE TABLE cache(id VARCHAR(255) PRIMARY KEY, data TEXT, expire UNSIGNED BIG INT, created UNSIGNED BIG INT, serialized BOOLEAN);
CREATE INDEX idx_cache_expire ON cache(expire);
```

```SQL
-- PostgreSQL
CREATE TABLE cache(id varchar(255) PRIMARY KEY NOT NULL, data text, expire BIGINT NOT NULL, created BIGINT NOT NULL, serialized smallint);
CREATE INDEX idx_cache_expire ON cache USING btree (expire);
```

If you want to create another cache bin, just change prefix the table name with 'cache_', for example:

```SQL
CREATE TABLE cache_content(id VARCHAR(255) PRIMARY KEY, data TEXT, expire UNSIGNED BIG INT, created UNSIGNED BIG INT, serialized BOOLEAN);
CREATE INDEX idx_cache_content_expire ON cache_content(expire);
```


### Configuration

Add the following to settings.lua:

```Lua
settings.cache = {
  default_ttl = 1*60*60, -- default: 1 hour
}
```
