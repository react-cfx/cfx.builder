import { cwd } from 'process'
import {
  join
  dirname
  extname
} from 'path'

import fse from 'fs-extra'
import merge from 'deepmerge'
import isPlainObject from 'is-plain-object'
import klawSync from 'klaw-sync'
import { gdf } from './util'

getConf = =>
  userConfPath = join cwd(), './cfx.conf.coffee'

  conf = {
    deft: gdf require './default.config.coffee'
    user:
      if fse.pathExistsSync userConfPath
      then gdf require userConfPath
      else {}
  }

  r = merge conf.deft, conf.user
  ,
    isMergeableObject: isPlainObject

  unless fse.pathExistsSync r.path.source
  then throw new Error 'Source dir was not found.'
  else r

fillPath = (conf) =>

  return unless conf?.path?
  return unless conf.path.source?
  return unless conf.path.dist?

  _cwd = cwd()
  _path =
    source: join _cwd, conf.path.source
    dist: join _cwd, conf.path.dist

  merge conf
  ,
    path: _path
  ,
    isMergeableObject: isPlainObject

fillExt = (conf) =>

  { exts } = conf
  _exts = (
    Object.keys exts
  ).reduce (r, c) =>
    {
      r...
      [c]: {
        exts[c]...
        (
          unless exts[c].ext?
          then ext: ".#{c}"
          else {}
        )...
      }
    }
  , {}

  {
    conf...
    exts: _exts
  }

filteExtsFromPlugins = (conf) =>

  {
    plugins
    exts
  } = conf

  return conf unless Array.isArray plugins
  return {
    conf...
    exts: {}
  } if plugins.length is 0

  _exts = plugins.reduce (r, c) =>
    {
      r...
      [c]: exts[c]
    }
  , {}
  {
    conf...
    exts: _exts
  }

pathFileList = (_path) =>
  paths = klawSync(
    _path
    nodir: true
  )
  .reduce (r, c) =>
    [
      r...
      c.path
    ]
  , []

sourceList = (conf) =>
  sourcePath = conf.path.source
  (
    pathFileList sourcePath
  )
  .reduce (r, c) =>
    file = c.replace conf.path.source, ''
    dir = dirname file
    ext = extname file
    [
      r...
      {
        file
        dir
        ext
        name: (
          (
            file.replace dir, ''
          ).replace ext, ''
        ).replace '/', ''
      }
    ]
  , []

fileListByExt = (fileList) =>
  fileList
  .reduce (r, c) =>
    { ext } = c
    {
      r...
      [ext]: [
        (
          if r[ext]?
          then r[ext]
          else []
        )...
        c
      ]
    }
  , {}

getSubExtFiles = (ext, fileList) =>
  prtext = extname ext
  subExt = ext
  .replace prtext, ''
  fileList[prtext]
  .reduce (r, c) =>
    [
      r...
      (
        if c.file.includes subExt
        then [c]
        else []
      )...
    ]
  , []

mergeFilesToConf = (conf, fileList) =>

  others = (
    Object.keys fileList
  )
  .reduce (_r, _c) =>
    {
      _r...
      [_c]: _c
    }
  , {}

  { exts } = conf

  _exts = (
    Object.keys exts
  )
  .reduce (r, c) =>
    {
      r...
      [c]: {
        exts[c]...
        (
          if fileList[exts[c].ext]?
          then(
            delete others[exts[c].ext]
            files: fileList[exts[c].ext]
          )
          else(
            files: getSubExtFiles exts[c].ext, fileList
          )
        )...
      }
    }
  , {}

  _others = (
    Object.keys others
  )
  .reduce (_r_, _c_) =>
    [
      _r_...
      fileList[_c_]...
    ]
  , []

  {
    conf...
    exts: _exts
    others: {
      conf.others... 
      files: _others
    }
  }

export {
  getConf
  fillPath
  fillExt
  filteExtsFromPlugins
  sourceList
  fileListByExt
  mergeFilesToConf
}
