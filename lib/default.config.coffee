import coffee from './plugins/coffee'
import jss from './plugins/jss'

export default

  path:
    source: 'source'
    dist: 'src'
  
  plugins: []

  exts:

    coffee:
      action: coffee
      exto: '.js'

    jssCoffee:
      action: jss
      ext: '.jss.coffee'
      exto: '.css'

    # js:
    # pug:
    # styl:
    # css:
    # vue:
    # md:
    # image:
    #   exts: [
    #     '.jpg'
    #     '.png'
    #   ]
    #   action: 'move'

  others:
    action: 'none'
