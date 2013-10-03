window.Opponent = cc.Node.extend(
  _cache: null
  _windowBounds: {}
  _sprite: null
  _stillFrame: null
  _moveAction: null
  _moveActionRunning: false
  _keys: {}
  _currentDirection: "" # U,D,L,R
  _movementSpeed: 3
  _playerId: ""
  _gameRef: null

  initWithPlayerIdAndGameRef: (playerId, gameRef) ->
    @_playerId = playerId
    @_gameRef = gameRef.child(playerId)
    @_cache = cc.SpriteFrameCache.getInstance()

    @_initIdLabel()
    @_initSprite()
    @_initActions()

    @_setWindowBounds()

    @_startListening()

  _setWindowBounds: ->
    winSize = cc.Director.getInstance().getWinSize()
    spriteSize = @_sprite.getContentSize()
    @_windowBounds["U"] = winSize.height - (spriteSize.height / 2)
    @_windowBounds["D"] = spriteSize.height / 2
    @_windowBounds["L"] = spriteSize.width / 2
    @_windowBounds["R"] = winSize.width - (spriteSize.width / 2)

  _initIdLabel: ->
    idLabel = cc.LabelTTF.create(@_playerId, "Arial", 14)
    idLabel.setPosition(0,40)
    idLabelShadow = cc.LabelTTF.create(@_playerId, "Arial", 14)
    idLabelShadow.setColor(cc.c4(0,0,0,0.3))
    idLabelShadow.setPosition(1,39)
    @addChild(idLabelShadow)
    @addChild(idLabel)

  _initSprite: ->
    @_cache.addSpriteFrames(s_ugonoth_plist, s_ugonoth)

    @_stillFrame = @_cache.getSpriteFrame("ugonoth-move-1.png")
    @_sprite = cc.Sprite.createWithSpriteFrame(@_stillFrame)

    @addChild(@_sprite)

  _initActions: ->
    frames = (@_cache.getSpriteFrame("ugonoth-move-" + i + ".png") for i in [1..16])
    moveAnimation = cc.Animation.create(frames, 0.05)
    @_moveAction = cc.RepeatForever.create(cc.Animate.create(moveAnimation))

  _startListening: ->
    @_gameRef.on "value", (snapshot) =>
      update = snapshot.val()
      @_updateDirection(update.currentDirection)
      @_updateSprite()
      @setPosition(update.x, update.y)

  _updateDirection: (newDirection) ->
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

window.Opponent.create = (playerId, gameRef) ->
  opponent = new Opponent()
  opponent.initWithPlayerIdAndGameRef(playerId, gameRef)
  opponent
