--[[
-- SQLite3
CREATE TABLE cache(id VARCHAR(255) PRIMARY KEY, data TEXT, expire UNSIGNED BIG INT, created UNSIGNED BIG INT, serialized BOOLEAN);
CREATE INDEX idx_cache_expire ON cache(expire);

-- PostgreSQL
CREATE TABLE cache(id varchar(255) PRIMARY KEY NOT NULL, data text, expire BIGINT NOT NULL, created BIGINT NOT NULL, serialized smallint);
CREATE INDEX idx_cache_expire ON cache USING btree (expire);

]]--

local schema = {}

schema['cache'] = {
	['description'] = '...',
	['fields'] = {
		['id'] = {
			['description'] = '...',
			['type'] = 'varchar', -- sqlite3 / postgres
			['not null'] = true, -- postgres
			['length'] = 255, -- sqlite3 / postgres
--			['unsigned'] = true,
--			['not null'] = true,
--			['auto increment'] = true,
		},
		['data'] = {
			['description'] = '...',
			['type'] = 'text', -- sqlite3
--			['not null'] = true,
--			['length'] = 25,
		},
		['expire'] = {
			['description'] = '...',
			['type'] = 'bigint',
			['unsigned'] = true,
		},
		['created'] = {
			['description'] = '...',
			['type'] = 'bigint',
			['unsigned'] = true,
		},
		['serialized'] = {
			['description'] = '...',
			['type'] = 'boolean', -- Should I support : ['type'] = { ['sqlite']='boolean', ['postgres']='smallint', }
		},
	},
	['primary key'] = 'id',
	['index'] = { -- index was not implemented yet, but should be this format...
		-- INDEX idx_cache_expire ON cache USING btree (expire);
		['cache'] = { -- table
			['idx_cache_expire'] = { -- index name
				['expire'] = "btree", -- indexed field, with method
			},
		},
	},
--	['foreign key'] = {
--		['playerId'] = 'players(id)',
--		['roleId'] = 'roles(id)'
--	}
}

return {schema = schema}
