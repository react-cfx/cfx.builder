import {
  getConf
  fillPath
  fillExt
  filteExtsFromPlugins
  sourceList
  fileListByExt
  mergeFilesToConf
} from './config'

import action from './action'

export default =>
  conf = filteExtsFromPlugins fillExt fillPath getConf()
  fileList = fileListByExt sourceList conf
  newConf = mergeFilesToConf conf, fileList
  action newConf
