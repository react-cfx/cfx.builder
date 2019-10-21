import { dirname } from 'path'
import fse from 'fs-extra'
import fs from 'fs'

writeTo = (fileTo, code) =>
  dirPath = dirname fileTo
  unless fse.pathExistsSync dirPath
    fse.mkdirpSync dirPath

  fs.writeFileSync fileTo, code, 'utf-8'

export {
  writeTo
}
