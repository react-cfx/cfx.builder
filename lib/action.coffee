import { join } from 'path'
import copy from './plugins/copy'

chooseAction = (action) =>
  switch action
    when 'copy'
    then copy
    when 'none'
    then =>
    else action

runAction = (
  {
    file
    exto
    action
    libs
  }
  {
    source
    dist
  }
) =>
  fileFrom = join source, file.file
  fileTo = join dist
  , "#{file.dir}/#{file.name}#{exto}"
  _action = chooseAction action
  if libs?
  then _action fileFrom, fileTo, libs
  else _action fileFrom, fileTo

handleConf = (patOfConf, {
  source
  dist
}) =>
  return unless patOfConf.files?
  patOfConf.files
  .forEach (file) =>
    runAction {
      file
      exto:
        if patOfConf.exto?
        then patOfConf.exto
        else file.ext
      action: patOfConf.action
      (
        if patOfConf.libs?
        then libs: patOfConf.libs
        else {}
      )...
    }, {
      source
      dist
    }

export default (conf) =>

  (
    Object.keys conf.exts
  )
  .forEach (ext) =>
    handleConf conf.exts[ext], conf.path

  handleConf conf.others, conf.path
