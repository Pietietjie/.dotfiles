local rows = {
  { 'ςερτυθιοπ',    'wertyuiop' },
  { 'ασδφγηξκλ',    'asdfghjkl' },
  { 'ζχψωβνμ',      'zxcvbnm' },
  { 'ΕΡΤΥΘΙΟΠ',     'ERTYUIOP' },
  { 'ΑΔΦΓΗΞΚΛ',     'ADFGHJKL' },
  { 'ΖΧΨΩΒΝΜ',      'ZXCVBNM' },
  { 'ΣϚϙϘ«»…·',     'WSqQ[]{}' },
  { 'άέήίόύώϊϋΐΰ',  'aehioyviyiy' },
  { 'ΆΈΉΊΌΎΏΪΫ',    'AEHIOYVIY' },
}

local entries = {}
for _, row in ipairs(rows) do
  local from, to = row[1], row[2]
  if vim.fn.strchars(from) ~= vim.fn.strchars(to) then
    error(('pietietjie.langmap: length mismatch for "%s" -> "%s"'):format(from, to))
  end
  table.insert(entries, from .. ';' .. to)
end

return table.concat(entries, ',')
