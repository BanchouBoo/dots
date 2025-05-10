local fennel = require('fennel').install()
local config_home = os.getenv('XDG_CONFIG_HOME') or os.getenv('HOME') .. '/.config'
fennel.path = fennel.path .. ';' .. config_home .. '/awesome/?.fnl'
fennel.path = fennel.path .. ';' .. config_home .. '/awesome/?/init.fnl'
require('config')
