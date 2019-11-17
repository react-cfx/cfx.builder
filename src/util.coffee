import dd from 'ddeyes'

toArray = (a) =>

  switch typeof a

    when 'string'
    then a.split ''

    when 'object'
    then(
      if Array.isArray a
      then a
      else(
        (
          Object.keys a
        )
        .reduce (r, c) =>
          [
            r...
            [c]: a[c]
          ]
        , []
      )
    )

    else [ a ]

last = (_a) =>
  a = toArray _a
  a[a.length - 1]

arrNo = (a, _n) =>
  n = Number.parseInt _n
  if n < 0
    if n <= (Number.parseInt "-#{a.length}")
      return 0
    else
      return a.length + n
  else if n >= a.length
    return a.length - 1
  else return n

slice = (_a, _start, _end) =>
  a = toArray _a
  start = arrNo a, _start
  end = arrNo a, _end

  if start is end
    [a[start]]
  else if start < end
    a[start..end]
  else 
    a[end..start]

export {
  last
  arrNo
  slice
}
