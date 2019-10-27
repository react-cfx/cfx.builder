import { cwd } from 'process'
import {
  join
  dirname
  extname
} from 'path'

import fse from 'fs-extra'
import merge from 'deepmerge'
import isPlainObject from 'is-plain-object'

_merge = (x, y) =>
  merge x, y
  ,
    isMergeableObject: isPlainObject 

import klawSync from 'klaw-sync'
import { gdf } from './util'

fillUserPlugins = (userConf) => 
  return userConf unless userConf?.exts?
  return userConf unless (typeof userConf.exts) is 'object'
  return userConf if userConf.plugins?
  {
    userConf...
    plugins: Object.keys userConf.exts 
  }

getConf = =>
  userConfPath = join cwd(), './cfx.conf.coffee'

  conf = {
    deft: gdf require './default.config.coffee'
    user: fillUserPlugins(
      if fse.pathExistsSync userConfPath
      then gdf require userConfPath
      else {}
    )
  }

  r = _merge conf.deft, conf.user

  unless fse.pathExistsSync r.path.source
  then throw new Error 'Source dir was not found.'
  else r

fillPath = (conf) =>

  return conf unless conf?.path?
  return conf unless conf.path.source?
  return conf unless conf.path.dist?

  _cwd = cwd()
  _path =
    source: join _cwd, conf.path.source
    dist: join _cwd, conf.path.dist

  _merge conf
  ,
    path: _path

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

excludesList = (conf) =>
  return [] unless conf?.excludes?

  unless Array.isArray conf.excludes
  then(
    if typeof conf.excludes is 'string'
    then [ conf.excludes ]
    else []
  )
  else conf.excludes

isExcluded = ({file, dir}, excludes) =>
  excludes.reduce (r, c) =>
    return r unless (typeof c) is 'string'
    return r if r is true
    return true if dir is c
    return true if file is c
    false
  , false

sourceList = (conf) =>
  sourcePath = conf.path.source
  _excludes = excludesList conf
  (
    pathFileList sourcePath
  )
  .reduce (r, c) =>
    file = c.replace conf.path.source, ''
    dir = dirname file
    ext = extname file
    return r if isExcluded {
      file
      dir
    }, _excludes
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
