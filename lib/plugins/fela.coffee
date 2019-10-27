import { gdf } from '../util'
import { writeTo } from './util'

export default (fileFrom, fileTo, libs) =>

  unless libs?.newFela?
    throw new Error 'newFela was not found.'

  { newFela } = libs

  stylSource = gdf require fileFrom
  cssCode = (
    newFela stylSource
  ).cssCode()

  writeTo fileTo, cssCode
