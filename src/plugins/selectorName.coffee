import dd from 'ddeyes'
import {
  classKey 
} from '../classKey'

export default =>

  (selectorName, actionPoint) =>

    return unless actionPoint is 'selectorName'

    ".#{classKey selectorName}"
