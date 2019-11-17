import dd from 'ddeyes'

pluginsCall = (plugins, actionPoint, defValue) =>
  if plugins?
  then(
    plugins.reduce (r, c) =>
      t = c r, actionPoint
      if t?
      then t
      else r
    , defValue
  )
  else defValue

recRenderer = (_selectorName, selectorBody, plugins) =>

  ### :PluginPoint
  # -- 'selectorName'
  ###
  selectorName =
    pluginsCall plugins
    , 'selectorName'
    , _selectorName

  ruleKs = Object.keys selectorBody
  ruleKs
  .reduce (r, ruleK) =>

    ruleV = selectorBody[ruleK]

    switch typeof ruleV
      when 'string'
      then(

        ### :PluginPoint
        # -- 'ruleK'
        ###
        _ruleK =
          pluginsCall plugins
          , 'ruleK'
          , ruleK

        ### :PluginPoint
        # -- 'ruleA'
        ###
        rule =
          pluginsCall plugins
          , 'ruleA'
          ,
            [_ruleK]: 
              ### :PluginPoint
              # -- 'ruleV'
              ###
              pluginsCall plugins
              , 'ruleV'
              , ruleV

        [
          name: r[r.length - 1].name
          body: {
            r[r.length - 1].body...
            rule...
          }
        ]

      )
      when 'object' 
      then(
        _c = recRenderer(
          ruleK
          ruleV
          plugins
        )
        [
          r...
          (
            _c.reduce (_r_, _c_) =>
              [
                _r_...
                name: [
                  r[r.length - 1].name...
                  _c_.name...
                ]
                body: _c_.body
              ]
            , []
          )...
        ]
      )
      else r
  , [
    name: [
      selectorName
    ]
    body: {}
  ]

Renderer = (cfstyls, plugins) =>

  selectorNames = Object.keys cfstyls
  selectorNames
  .reduce (_r, selectorName) =>
    [
      _r...
      (
        recRenderer selectorName
        , cfstyls[selectorName] 
        , plugins
      )...
    ]
  , []
  .reduce (r, c) =>

    ### :PluginPoind
    # -- 'classNames'
    ###
    classNames = # c.name
      pluginsCall plugins
      , 'classNames'
      , c.name

    {
      r...
      [classNames.join ' ']: c.body
    }

  , {}

createRenderer = (options) =>
  if options?.plugins?
    {
      plugins
    } = options

  render: (cfstyls) =>
    Renderer cfstyls, plugins

renderToString = (render) =>
  return '' unless (typeof render) is 'object'
  (
    Object.keys render
  )
  .reduce (r, c) =>
    rule = (
      Object.keys render[c]
    )
    .reduce (_r, _c, _i, _a) =>
      [
        _r...
        [
          "  "
          "#{_c}: #{render[c][_c]}"
          ";"
          # (
          #   if _i is (_a.length - 1)
          #   then []
          #   else [ ";" ]
          # )...
        ]
        .join ''
      ]
    , []
    .join "\n"
    [
      (
        if r.length is 0
        then []
        else [r]
      )...
      """
      #{c}: {\n#{rule}\n}
      """
    ]
    .join "\n"
  , []

export {
  createRenderer
  renderToString
}
