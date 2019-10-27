import dd from 'ddeyes'
import CoffeeScript from 'coffeescript'
import { create } from 'jss'
import preset from 'jss-preset-default'
import { createRenderer } from 'fela'
import { renderToString } from 'fela-tools'

export default

  # plugins: [
  #   'coffee'
  #   'jssCoffee'
  #   'felaCoffee'
  # ]

  exts:

    coffee:
      libs: {
        CoffeeScript
      }

    jssCoffee:
      libs:
        newJss: (styles) =>
          jss = create().setup preset()
          sheet = jss.createStyleSheet styles

          classes = => sheet.classes
          dd classes()

          cssCode: => sheet.toString()
          classes: => classes()

    felaCoffee:
      libs:
        newFela: (styles) =>
          renderer = createRenderer()
          classes = =>
            (
              Object.keys styles
            )
            .reduce (r, c) =>
              {
                r...
                [c]: renderer.renderRule => styles[c]
              }
            , {}
          dd classes()

          cssCode: => renderToString renderer
          classes: => classes()

  excludes: [
    '/hello.coffee'
    '/hello'
  ]

  others:
    action: 'copy'
