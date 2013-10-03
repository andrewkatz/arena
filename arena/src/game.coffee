window.GameLayer = cc.Layer.extend(
  _player: null
  _playerId: null
  _gameId: null
  _serverRef: null
  _gameRef: null
  _players: []
  _playersLabel: null
  _opponents: []

  init: ->
    @_super()
    @_initServer()
    @_initTileMap()
    @_initPlayer()

    @setKeyboardEnabled(true)
    @scheduleUpdate()

    true

  _initServer: ->
    @_serverRef = new Firebase("https://arena-game.firebaseio.com/")

    params = @_params()
    @_gameId = params["gameId"] or @_randomId()
    @_playerId = params["playerId"] or @_randomId()

    console.log("GameId: " + @_gameId)
    console.log("PlayerId: " + @_playerId)

    $("#gameId").html(@_gameId)

    @_gameRef = @_serverRef.child(@_gameId)


    @_gameRef.child("started").once "value", (snapshot) =>
      started = snapshot.val()

      if started == "true"
        @_startGame()

    playersRef = @_gameRef.child("players")

    playersRef.on "child_added", (snapshot) =>
      @_addPlayer(snapshot.val()["playerId"])

    playersRef.push(playerId: @_playerId) unless @_playerExists(@_playerId)


  _startGame: ->
    console.log("Start game")

  _gameAlreadyStarted: ->

  _params: ->
    prmstr = window.location.search.substr(1)
    prmarr = prmstr.split ("&")
    params = {}

    for i in [0..prmarr.length - 1]
      tmparr = prmarr[i].split("=")
      params[tmparr[0]] = tmparr[1]

    params

  _randomId: ->
    text = ""
    possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    text += possible.charAt(Math.floor(Math.random() * possible.length)) for i in [0..4]
    text

  _addPlayer: (playerId) ->
    if !@_playerExists(playerId)
      @_players.push(playerId)
      @_drawPlayersList()

      if playerId isnt @_playerId
        opponent = Opponent.create(playerId, @_gameRef)
        @_opponents.push(opponent)
        @addChild(opponent)

  _playerExists: (playerId) ->
    @_players.indexOf(playerId) > -1

  _initPlayer: ->
    size = cc.Director.getInstance().getWinSize()
    @_player = Player.create(@_playerId, @_gameRef)
    @_player.setPosition(size.width / 2, size.height / 2)
    @addChild(@_player)

  _initTileMap: ->
    tileMap = cc.TMXTiledMap.create(s_brick_tmx, s_brick)
    @addChild(tileMap)

  _drawPlayersList: ->
    playersList = ("<li>" + playerId + "</li>" for playerId in @_players)
    $("#playersList").html("<ul>" + playersList + "</ul>")

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
