import fs from 'fs'
import { makeSureDirPath } from './util'

export default (fileFrom, fileTo) =>
  makeSureDirPath fileTo
  fs.copyFileSync fileFrom, fileTo
