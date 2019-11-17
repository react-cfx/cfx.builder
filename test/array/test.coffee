import dd from 'ddeyes'
import 'shelljs/make'
import {
  last
  arrNo
  slice
} from '../../src/util'

target.all = =>
  dd 'Hello World!!!'

  dd arrNo [0, 1], -3
  dd arrNo [0, 1], -2
  dd arrNo [0, 1], -1
  dd arrNo [0, 1], 0
  dd arrNo [0, 1], 1
  dd arrNo [0, 1], 2

  dd slice [0, 1] , 0, -2

target.last = =>
  dd last [0..10]
  dd last [0]
  dd last [10]
  dd last -1
  dd last 0
  dd last 10
  dd last 'Hello'
  dd last
    a: 'hello'
    b: 'world'

target.slice = =>
  a = [0..10]
  dd a.length
  dd arrNo a, -11
  dd arrNo a, -12
  dd arrNo a, -10
  dd a[arrNo a, -1]

  dd slice a, -2, 3
  dd slice a, -2, -2
  dd slice a, 0, -1
