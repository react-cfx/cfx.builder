# import dd from 'ddeyes'

import {
  last
  slice
} from './util'

# -----------------------

isUpper = (c) =>
  if /[A-Z]/.test c
  then true
  else false

isLower = (c) =>
  if /[a-z]/.test c
  then true
  else false

isChar = (char) =>
  if (
    isUpper char
  ) or (
    isLower char
  )
  then true
  else false

groupByChars = (_str) =>
  return _str unless (typeof _str) is 'string'
  str = _str.split ''

  diff = (r, c) =>
    [
      (
        if r.length <= 1
        then []
        else slice r, 0, -2
      )...
      "#{last r}#{c}"
    ]

  isGroupItem = (c) =>
    if (
      isChar c
    ) or (
      c is '-'
    )
    then true
    else false

  str.reduce (r, c, i) =>
    if i is 0
    then [ "#{c}" ]
    else (
      if(
        isGroupItem last (
          last r
        ).split ''
      )
      then(
        if isGroupItem c
        then diff r, c
        else [
          r...
          c
        ]
      )
      else(
        if isGroupItem c
        then [
          r...
          c
        ]
        else diff r, c
      )
    )
  , []

# -----------------------

isSlash = (cs) =>

  return false if (
    groupByChars cs
  )
  .length isnt 1

  if cs.includes '-'
  then true
  else false

isCamel = (_cs) =>

  return false if (
    groupByChars _cs
  )
  .length isnt 1

  cs = _cs.split ''
  t =
    cs
    .reduce (r, c) =>
      lower:
        if isLower c
        then r.lower + 1
        else r.lower
      upper:
        if isUpper c
        then r.upper + 1
        else r.upper
    ,
      lower: 0
      upper: 0

  if (
    not (isUpper cs[0])
  ) and (
    t.upper isnt 0
  ) and (
    (t.lower + t.upper) is cs.length
  )
  then true
  else false

# -----------------------


msLower = (cs) =>

  _msLower = (c) =>
    if isUpper c
    then c.toLowerCase()
    else c

  if cs.length is 1
  then _msLower cs
  else(
    cs
    .split ''
    .reduce (r, c) =>
      "#{r}#{_msLower c}"
    , ''
  )

camelToSlash = (k) =>

  return '' if (
    k.length is 0
  ) or (
    typeof k isnt 'string'
  )
  return k if isSlash k

  ka = k.split ''

  [
    msLower ka[0]
    (
      if k.length > 2
      then slice ka, 1, -2
      else []
    )...
    (
      if k.length >= 2
      then [ last ka ]
      else []
    )...
  ] 
  .reduce (r, c, i, a) =>
    _c = msLower c
    return [ _c ] if i is 0

    if isUpper c
    then [
      r...
      _c
    ]
    else(
      [
        (
          if r.length > 1
          then slice r, 0, -2
          else []
        )...
        "#{last r}#{_c}"
      ]
    )
  , []
  .reduce (r, c) =>
    return r if c is ''
    [
      r...
      c
    ]
  , []
  .join '-'

slashToCamel = (k) =>

  return '' if (
    k.length is 0
  ) or (
    typeof k isnt 'string'
  )
  return k unless isSlash k

  (
    k.split '-'
  )
  .reduce (r, c, i) =>
    ca = c.split ''
    [
      r...
      if i >= 1
      then(
        [
          ca[0].toUpperCase()
          if ca[1..].length is 1
          then msLower ca[1..]
          else msLower ca[1..].join ''
        ].join ''
      )
      else msLower ca.join ''
    ]
  , []
  .join ''

msSlash = (slash) =>
  return slash unless isSlash slash
  (
    slash.split '-'
  )
  .reduce (r, c) =>
    [
      r...
      msLower c
    ]
  , []
  .join '-'

classKey = (cs) =>
  return '' if (
    cs.length is 0
  ) or (
    typeof cs isnt 'string'
  )

  csa = groupByChars cs
  return msSlash camelToSlash cs if csa.length is 1

  csa.reduce (r, c) =>
    [
      r...
      if isCamel c
      then(
        msSlash camelToSlash c
      )
      else(
        if isSlash c
        then(
          msSlash c
        )
        else c
      )
    ]
  , []
  .join ''

withPoint = (c) => ".#{c}"
withOutPoint = (c) =>
  return c unless c[0] is '.'
  c[1..].join ''

classTo = (c) => withOutPoint slashToCamel c
toClass = (c) => withPoint camelToSlash c

ccs = (km) =>
  (
    Object.keys km
  )
  .reduce (r, c) =>
    {
      r...
      [c]: camelToSlash c
    }
  , {}

export {
  isSlash
  isCamel

  groupByChars

  camelToSlash
  slashToCamel

  classKey

  withPoint
  withOutPoint

  classTo
  toClass

  ccs
}
