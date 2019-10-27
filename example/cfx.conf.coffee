import dd from 'ddeyes'
import CoffeeScript from 'coffeescript'
import { create } from 'jss'
import preset from 'jss-preset-default'
import { createRenderer } from 'fela'
import { renderToString } from 'fela-tools'
import css from 'css'

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
          globalHandler = (globalStyles) =>
            (
              Object.keys globalStyles
            )
            .forEach (i) =>
              dd globalStyles[i]
              renderer.renderStatic globalStyles[i], i
          classes = =>
            (
              Object.keys styles
            )
            .reduce (r, c) =>
              {
                r...
                (
                  if c is '@global'
                  then(
                    globalHandler styles[c]
                    {} 
                  )
                  else [c]: renderer.renderRule => styles[c]
                )...
              }
            , {}
          dd classes()

          cssCode: => css.stringify css.parse renderToString renderer
          classes: => classes()

  excludes: [
    '/hello.coffee'
    '/hello'
  ]

  others:
    action: 'copy'
