var join = require('path').join;
require('cfx.require-plugin-coffee/register')();
require(
  join(
    __dirname
  , '../lib/index.coffee'
  )
).default()
