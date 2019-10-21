import dd from 'ddeyes'
import { gdf } from '../util'
import { writeTo } from './util'

export default (fileFrom, fileTo, libs) =>

  unless libs?.jss?
    throw new Error 'jss was not found.'
  unless libs?.SheetsRegistry?
    throw new Error 'SheetsRegistry was not found.'

  {
    jss
    SheetsRegistry
  } = libs

  stylSource = gdf require fileFrom

  sheets = new SheetsRegistry()
  sheet = jss.createStyleSheet stylSource
  sheets.add sheet
  cssCode = sheets.toString()

  writeTo fileTo, cssCode
