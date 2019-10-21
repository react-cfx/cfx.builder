import { dirname } from 'path'
import fse from 'fs-extra'
import fs from 'fs'

makeSureDirPath = (path) =>
  dirPath = dirname path
  unless fse.pathExistsSync dirPath
    fse.mkdirpSync dirPath

writeTo = (fileTo, code) =>
  makeSureDirPath fileTo
  fs.writeFileSync fileTo, code, 'utf-8'

export {
  makeSureDirPath
  writeTo
}
