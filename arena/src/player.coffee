window.Player = cc.Node.extend(
  _cache: null
  _windowBounds: {}
  _sprite: null
  _stillFrame: null
  _moveAction: null
  _moveActionRunning: false
  _keys: {}
  _currentDirection: "" # U,D,L,R
  _movementSpeed: 3

  init: ->
    @_super()

    @_cache = cc.SpriteFrameCache.getInstance()

    @_initSprite()
    @_initActions()

    winSize = cc.Director.getInstance().getWinSize()
    spriteSize = @_sprite.getContentSize()
    @_windowBounds["U"] = winSize.height - (spriteSize.height / 2)
    @_windowBounds["D"] = spriteSize.height / 2
    @_windowBounds["L"] = spriteSize.width / 2
    @_windowBounds["R"] = winSize.width - (spriteSize.width / 2)

  _initSprite: ->
    @_cache.addSpriteFrames(s_ugonoth_plist, s_ugonoth)

    @_stillFrame = @_cache.getSpriteFrame("ugonoth-move-1.png")
    @_sprite = cc.Sprite.createWithSpriteFrame(@_stillFrame)

    @addChild(@_sprite)

  _initActions: ->
    frames = (@_cache.getSpriteFrame("ugonoth-move-" + i + ".png") for i in [1..16])
    moveAnimation = cc.Animation.create(frames, 0.05)
    @_moveAction = cc.RepeatForever.create(cc.Animate.create(moveAnimation))

  onKeyUp: (e) ->
    @_keys[e] = false

  onKeyDown: (e) ->
    @_keys[e] = true

  update: ->
    @_updateDirection()
    @_updateSprite()
    @_updatePosition()

  _updateDirection: ->
    if @_keys[cc.KEY.w] || @_keys[cc.KEY.up]
      verticalDirection = "U"
    else if @_keys[cc.KEY.s] || @_keys[cc.KEY.down]
      verticalDirection = "D"
    else
      verticalDirection = ""

    if @_keys[cc.KEY.a] || @_keys[cc.KEY.left]
      horizontalDirection = "L"
    else if @_keys[cc.KEY.d] || @_keys[cc.KEY.right]
      horizontalDirection = "R"
    else
      horizontalDirection = ""

    newDirection = verticalDirection + horizontalDirection

    if newDirection is ""
      if @_moveActionRunning
        @_sprite.stopAction(@_moveAction)
        @_sprite.setDisplayFrame(@_stillFrame)
        @_moveActionRunning = false
    else
      @_currentDirection = newDirection

      if !@_moveActionRunning
        @_sprite.runAction(@_moveAction)
        @_moveActionRunning = true

  _updateSprite: ->
    @_sprite.setRotation(@_rotationForDirection())

  _updatePosition: ->
    return unless @_moveActionRunning

    position = @getPosition()

    if @_currentDirection.indexOf("U") > -1 and position.y < @_windowBounds["U"]
      position.y += @_movementSpeed
    else if @_currentDirection.indexOf("D") > -1 and position.y > @_windowBounds["D"]
      position.y -= @_movementSpeed

    if @_currentDirection.indexOf("L") > -1 and position.x > @_windowBounds["L"]
      position.x -= @_movementSpeed
    else if @_currentDirection.indexOf("R") > -1 and position.x < @_windowBounds["R"]
      position.x += @_movementSpeed

    @setPosition(position)

  _rotationForDirection: ->
    switch @_currentDirection
      when "U" then 0.0
      when "D" then 180.0
      when "L" then -90.0
      when "R" then 90.0
      when "UL" then -45.0
      when "UR" then 45.0
      when "DL" then -135.0
      when "DR" then 135.0
      else 0.0
)

window.Player.create = ->
  player = new Player()
  player.init()
  player
