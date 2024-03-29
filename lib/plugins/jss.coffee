import { gdf } from '../util'
import { writeTo } from './util'

export default (fileFrom, fileTo, libs) =>

  unless libs?.newJss?
    throw new Error 'newJss was not found.'

  {
    newJss
  } = libs

  stylSource = gdf require fileFrom
  cssCode = (
    newJss stylSource
  ).cssCode()

  writeTo fileTo, cssCode
