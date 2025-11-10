require('config.leader')
require('config.lazy')
require('config.options')
require('config.keymaps')
require('lazy').setup('plugins')

-- Must load after Lazy
require('config.theme')
