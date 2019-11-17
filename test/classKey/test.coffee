import dd from 'ddeyes'
import 'shelljs/make'

target.all = =>
  dd 'Hello World!!!'

import {
  isSlash
  isCamel

  groupByChars

  slashToCamel
  camelToSlash
  classKey
} from '../../src/classKey'

target.cs = =>

  [
    "Hello"
    "heLlo"
    "he-Llo"
  ]
  .forEach (i) =>
    dd i
    dd isSlash i
    dd isCamel i

target.group = =>
  dd groupByChars "fjiejf..jH-ji-fej123jHHjfeeiiII@@!H"

target.classkeyI = =>
  p = (cs, func) =>
    dd "'#{cs}' => '#{func cs}'"

  pstc = (cs) => p cs, slashToCamel
  pcts = (cs) => p cs, camelToSlash

  pstc 'h'
  pstc 'H'
  pstc 'he'
  pstc 'He'
  pstc 'hE'
  pstc 'hello'
  pstc 'HEll-O'
  pstc 'hello-With-hand'

  pcts 'h'
  pcts 'H'
  pcts 'he'
  pcts 'He'
  pcts 'hE'
  pcts 'hello'
  pcts 'HEll-O'
  pcts 'hello-With-hand'

target.classkey = =>
  p = (cs) =>
    dd "'#{cs}' => '#{classKey cs}'"

  p 'h'
  p 'H'
  p 'he'
  p 'He'
  p 'hE'
  p 'hello'
  p 'HEll-O'
  p 'hello-With-hand'
  p 'helloWith-hand'
  p 'helloWithHand'

  p "fjiejf..jH-ji-fej123jHHjfeeiiII@@!H"
