import fs from 'fs'
import { writeTo } from './util'

export default (fileFrom, fileTo, libs) =>

  unless libs?.CoffeeScript?
    throw new Error 'CoffeeScript was not found.'

  { CoffeeScript } = libs
  coffeeSource = fs.readFileSync fileFrom, 'utf-8'

  jsCode = CoffeeScript.compile coffeeSource
    , bare: true

  writeTo fileTo, jsCode
