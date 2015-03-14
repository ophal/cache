local _M = {bin = 'cache'}
ophal.modules.cache = _M

local time, table_dump = os.time, seawolf.contrib.table_dump
local config, xtable = settings.cache, seawolf.contrib.seawolf_table

function _M.cron()
  db_query('DELETE FROM cache WHERE expire <= ?', time())
end

function _M.get(t, key)
  local data_function, err, parsed, data

  local rs = db_query('SELECT * FROM ' .. t.bin .. ' WHERE id = ?', key)
  local result = rs:fetch(true)

  if result then
    if result.serialized then
      data_function, err = loadstring(result.data)
      if data_function then
        setfenv(data_function, {}) -- empty environment
        parsed, result.data, err = pcall(data_function)
      end
      if err then
        error(format('cache: %s', err))
      end
    end
    return result
  end
end

-- Write session data and end session
function _M.set(t, key, data, expire)
  local serialized, rawdata, saved, err

  if type(data) == 'table' then
    rawdata = xtable({'return '})
    serialized, err = pcall(table_dump, data, function (s) rawdata:append(s) end)
    if serialized then
      data = rawdata:concat()
    else
      error(format('cache: %s', err))
    end    
  else
    data = tostring(data)
  end

  db_query('DELETE FROM ' .. t.bin .. ' WHERE id = ?', key)
  db_query('INSERT INTO ' .. t.bin .. '(id, data, expire, created, serialized) VALUES(?, ?, ?, ?, ?)',
    key,
    data,
    expire or time() + config.default_ttl,
    time(),
    serialized
  )

  return t
end

local mt = {}

function mt.__call(t, bin)
  return _M:new(bin)
end

-- Build a new instance of cache interface
function _M:new(bin)
  local m = {}

  for k in pairs(_M) do
    m[k] = _M[k]
  end

  m.bin = 'cache_' .. bin

  setmetatable(m, mt)

  return m
end

setmetatable(_M, mt)

return _M