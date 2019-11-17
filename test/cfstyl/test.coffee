import dd from 'ddeyes'
import 'shelljs/make'

target.all = =>
  dd 'Hello World!!!'

import {
  createRenderer
  renderToString
} from '../../src'
import {
  camlToSlash
  ccs
} from '../../src/classKey'
import selectorNamePlugin from '../../src/plugins/selectorName'
import classNamesPlugin from '../../src/plugins/classNames'
import ruleKPlugin from '../../src/plugins/ruleK'

target.render = =>

  subSelectorName = (selectorName, parentName) =>
    if selectorName.includes '&'
    then selectorName.replace '&', parentName
    else "#{parentName} #{selectorName}"

  plugins = [
    selectorNamePlugin()
    classNamesPlugin()
    ruleKPlugin()
  ]

  renderer = createRenderer {
    plugins
  }

  cs = ccs {
    'pageIndex'
  }

  console.log renderToString renderer.render

    page:

      position: 'relative'
      backgroundColor: '#f7f7f7'

      pageIndex:
        position: 'relative'
        backgroundColor: '#f8f8f8'

        "pageIndex.classTemp":
          position: 'relative'
          backgroundColor: '#f9f9f9'
