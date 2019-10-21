import dd from 'ddeyes'
import 'shelljs/make'

import {
  getConf
  fillPath
  fillExt
  filteExtsFromPlugins
  sourceList
  fileListByExt
  mergeFilesToConf
} from '../lib/config'

import action from '../lib/action'

target.getConf = =>
  dd getConf()

target.fillPath = =>
  conf = getConf()
  dd fillPath conf

target.fillExt = =>
  conf = getConf()
  dd fillExt conf

target.filteExtsFromPlugins = =>
  conf = getConf()
  dd filteExtsFromPlugins conf

target.sourceList = =>
  conf = filteExtsFromPlugins fillExt fillPath getConf()
  dd sourceList conf

target.fileListByExt = =>
  conf = filteExtsFromPlugins fillExt fillPath getConf()
  fileList = sourceList conf
  dd fileListByExt fileList

keyToEmpty = (obj) => 
  (
    Object.keys obj
  )
  .reduce (r, c) =>
    {
      r...
      [c]: {}
    }
  , {}

target.mergeFilesToConf = =>
  conf = filteExtsFromPlugins fillExt fillPath getConf()
  fileList = fileListByExt sourceList conf
  newConf = mergeFilesToConf conf, fileList

  _exts = (
    Object.keys newConf.exts
  )
  .reduce (r, c) =>
    {
      r...
      [c]: {
        newConf.exts[c]...
        libs: keyToEmpty newConf.exts[c].libs
      }
    }
  , {}

  console.log JSON.stringify(
    {
      newConf...
      exts: _exts
    }
    null
    2
  )

target.action = =>
  conf = filteExtsFromPlugins fillExt fillPath getConf()
  fileList = fileListByExt sourceList conf
  newConf = mergeFilesToConf conf, fileList
  action newConf
