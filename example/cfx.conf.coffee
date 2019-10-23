import CoffeeScript from 'coffeescript'
import jss, { SheetsRegistry } from 'jss'

export default

  plugins: [
    'coffee'
    'jssCoffee'
  ]

  exts:

    coffee:
      libs: {
        CoffeeScript
      }

    jssCoffee:
      libs: {
        jss
        SheetsRegistry
      }

  excludes: [
    '/hello.coffee'
    '/hello'
  ]

  others:
    action: 'copy'
