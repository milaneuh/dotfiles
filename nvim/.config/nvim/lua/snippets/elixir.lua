local ls = require("luasnip")

local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

local separator = "{}"

local snippets_formatted = {}

-- Reminder :
--   If default options add it in parameters (ex: IO.inspect and limit:infinity)
--   If a parameter is in a list or a tuple, surround it in parameters (ex: Map.take)

local snippets = {
  { command = 'Enum.all?',         parameters = { 'enum' },                     map = 'eall' },
  { command = 'Enum.any?',         parameters = { 'enum' },                     map = 'eany' },
  { command = 'Enum.at',           parameters = { 'enum', 'index' },            map = 'eat' },
  { command = 'Enum.count',        parameters = { 'enum' },                     map = 'ecount' },
  { command = 'Enum.drop',         parameters = { 'enum' },                     map = 'edrop' },
  { command = 'Enum.each',         parameters = { 'enum', 'fun' },              map = 'eeach' },
  { command = 'Enum.fetch',        parameters = { 'enum', 'acc', 'fun' },       map = 'efetch' },
  { command = 'Enum.filter',       parameters = { 'enum', 'fun' },              map = 'efilter' },
  { command = 'Enum.join',         parameters = { 'enum', "joiner" },           map = 'ejoin' },
  { command = 'Enum.map',          parameters = { 'enum', 'fun' },              map = 'emap' },
  { command = 'Enum.group_by',     parameters = { 'enum', 'fun' },              map = 'egroup_by' },
  { command = 'Enum.flatmap',      parameters = { 'enum', 'fun' },              map = 'eflatmap' },
  { command = 'Enum.max_by',       parameters = { 'enum', 'fun' },              map = 'emax_by' },
  { command = 'Enum.min_by',       parameters = { 'enum', 'fun' },              map = 'emin_by' },
  { command = 'Enum.reduce',       parameters = { 'enum', 'index' },            map = 'ered' },
  { command = 'Enum.reject',       parameters = { 'enum', 'fun' },              map = 'ereject' },
  { command = 'Enum.reverse',      parameters = { 'enum', },                    map = 'ereverve' },
  { command = 'Enum.sort',         parameters = { 'enum', },                    map = 'esort' },
  { command = 'Enum.take',         parameters = { 'enum', 'amount' },           map = 'etake' },
  { command = 'Enum.to_list',      parameters = { 'enum' },                     map = 'eto_list' },
  { command = 'Enum.uniq',         parameters = { 'enum' },                     map = 'euniq' },
  { command = 'Enum.zip',          parameters = { 'enum', 'enum' },             map = 'ezip' },
  { command = 'IO.inspect',        parameters = { 'term', 'limit: :infinity' }, map = 'iins' },
  { command = 'Kernel.then',       parameters = { 'value', 'fun' },             map = 'kthen' },
  { command = 'List.delete',       parameters = { 'list', 'elem' },             map = 'ldelete' },
  { command = 'List.delete_at',    parameters = { 'list', 'index' },            map = 'ldelete_qt' },
  { command = 'List.first',        parameters = { 'list' },                     map = 'lfirst' },
  { command = 'List.flatten',      parameters = { 'list' },                     map = 'lflatten' },
  { command = 'List.insert_at',    parameters = { 'list', 'value' },            map = 'linsertat' },
  { command = 'List.last',         parameters = { 'list' },                     map = 'llast' },
  { command = 'List.zip',          parameters = { 'list', 'list' },             map = 'lzip' },
  { command = 'Map.delete',        parameters = { 'map', 'key' },               map = 'mdel' },
  { command = 'Map.drop',          parameters = { 'map', 'key' },               map = 'mdrop' },
  { command = 'Map.get',           parameters = { 'map', 'key' },               map = 'mget' },
  { command = 'Map.has_keys?',     parameters = { 'map', 'key' },               map = 'mhaskey' },
  { command = 'Map.keys',          parameters = { 'map' },                      map = 'mkeys' },
  { command = 'Map.merge',         parameters = { 'map1', 'map2' },             map = 'mmerge' },
  { command = 'Map.pop',           parameters = { 'map', 'key' },               map = 'mpop' },
  { command = 'Map.put',           parameters = { 'map', 'key', 'value' },      map = 'mput' },
  { command = 'Map.replace',       parameters = { 'map', 'key', 'value' },      map = 'mreplace' },
  { command = 'Map.take',          parameters = { 'map', 'keys' },              map = 'mtake' },
  { command = 'Map.value',         parameters = { 'map' },                      map = 'mvalues' },
  { command = 'String.downcase',   parameters = { 'string' },                   map = 'sdowncase' },
  { command = 'String.first',      parameters = { 'string' },                   map = 'sfirst' },
  { command = 'String.last',       parameters = { 'string' },                   map = 'slast' },
  { command = 'String.length',     parameters = { 'string' },                   map = 'slength' },
  { command = 'String.match?',     parameters = { 'string', 'regex' },          map = 'smatch' },
  { command = 'String.reverse',    parameters = { 'string' },                   map = 'sreverse' },
  { command = 'String.split',      parameters = { 'string', 'pattern' },        map = 'ssplit' },
  { command = 'String.start_with', parameters = { 'string', 'regex' },          map = 'sstart_with' },
  { command = 'String.trim',       parameters = { 'string' },                   map = 'strim' },
  { command = 'String.upcase',     parameters = { 'string' },                   map = 'supcase' },
  { command = 'length',            parameters = { 'list' },                     map = 'length' },
  { command = 'pop_in',            parameters = { 'path' },                     map = 'pop_in' },
  { command = 'put_in',            parameters = { 'data', 'key', 'value' },     map = 'put_in' },
  { command = 'spawn_link',        parameters = { 'fun' },                      map = 'spawn_link' },
}


local shallow_copy = function(t)
  local t2 = {}
  for k, v in pairs(t) do
    t2[k] = v
  end
  return t2
end

local extract_parameter = function(parameters, anomyne)
  local result = "("
  for index, value in ipairs(parameters) do
    if value == "fun" and anomyne == true then
      result = result .. '& &1' .. separator
    elseif value == "fun" then
      result = result .. 'fn ' .. separator .. ' -> ' .. '\n\t' .. separator .. '\n' .. 'end'
    elseif value == "keys" then
      result = result .. '[:' .. separator .. ']'
    else
      result = result .. separator
    end

    if index == #parameters then
      result = result
    else
      result = result .. ', '
    end
  end
  return result .. ')'
end

local is_function_in_parameters = function(parameters)
  for _, value in pairs(parameters) do
    if value == 'fun' then
      return true
    end
  end
  return false
end

local create_snippet_map = function(snippet)
  local command = ''
  local parameter = {}
  local r = {}
  local result = {}

  -- command()
  parameter = shallow_copy(snippet['parameters'])
  command = snippet['command'] .. extract_parameter(parameter, true)
  r = { command = command, parameters = parameter, map = snippet['map'], is_fun_ano = true }
  table.insert(result, r)

  -- pcommand()
  parameter = shallow_copy(snippet['parameters'])
  table.remove(parameter, 1)
  command = '|> ' .. snippet['command'] .. extract_parameter(parameter, true)
  r = { command = command, parameters = parameter, map = 'p' .. snippet['map'], is_fun_ano = true }
  table.insert(result, r)

  if is_function_in_parameters(parameter) then
    -- commandf
    parameter = shallow_copy(snippet['parameters'])
    command = snippet['command'] .. extract_parameter(parameter, false)
    table.insert(parameter, 'fun')
    r = { command = command, parameters = parameter, map = snippet['map'] .. 'f', is_fun_ano = false }
    table.insert(result, r)

    -- pcommandf
    parameter = shallow_copy(snippet['parameters'])
    table.remove(parameter, 1)
    command = '|> ' .. snippet['command'] .. extract_parameter(parameter, false)
    table.insert(parameter, 'fun')
    r = { command = command, parameters = parameter, map = 'p' .. snippet['map'] .. 'f', is_fun_ano = false }
    table.insert(result, r)
  end
  return result
end

local apply_i = function(t, is_fun_ano)
  local result = {}
  for key, value in ipairs(t) do
    if value == 'fun' and is_fun_ano == true then
      table.insert(result, i(key, ""))
    elseif value == 'fun' then
      table.insert(result, i(key, ""))
    else
      table.insert(result, i(key, value))
    end
  end
  return result
end

for u = 1, #snippets do
  local result = create_snippet_map(snippets[u])
  for j = 1, #result do
    table.insert(
      snippets_formatted,
      s(result[j]['map'],
        fmt(result[j]['command'], apply_i(result[j]['parameters'], result[j]['is_fun_ano']), { delimiters = separator, }))
    )
  end
end

ls.add_snippets("elixir", snippets_formatted)
