window.GameLayer = cc.Layer.extend(
  _player: null

  init: ->
    @_super()

    size = cc.Director.getInstance().getWinSize()

    tileMap = cc.TMXTiledMap.create(s_brick_tmx, s_brick)
    @addChild(tileMap)

    @_player = Player.create()
    @_player.setPosition(size.width / 2, size.height / 2)
    @addChild(@_player)

    if sys.capabilities.hasOwnProperty("keyboard")
      @setKeyboardEnabled(true)

    @scheduleUpdate()

    true

  update: ->
    @_player.update()

  onKeyUp: (e) ->
    @_player.onKeyUp(e)

  onKeyDown: (e) ->
    @_player.onKeyDown(e)
)

window.GameScene = cc.Scene.extend(
  onEnter: ->
    @_super()
    layer = new GameLayer()
    layer.init()
    @addChild(layer)
)
