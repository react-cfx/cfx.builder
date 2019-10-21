import { join } from 'path'

export default (conf) =>
  { exts } = conf
  {
    source
    dist
  } = conf.path
  (
    Object.keys exts
  ).forEach (ext) =>
    if exts[ext].files?
      exts[ext].files
      .forEach (file) =>
        fileFrom = join source, file.file
        fileTo = join dist
        , "#{file.dir}/#{file.name}#{exts[ext].exto}"
        exts[ext].action fileFrom, fileTo, exts[ext].libs
