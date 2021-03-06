// Generated by CoffeeScript 1.6.3
(function() {
  window.Opponent = cc.Node.extend({
    _cache: null,
    _windowBounds: {},
    _sprite: null,
    _stillFrame: null,
    _moveAction: null,
    _moveActionRunning: false,
    _keys: {},
    _currentDirection: "",
    _movementSpeed: 3,
    _playerId: "",
    _gameRef: null,
    initWithPlayerIdAndGameRef: function(playerId, gameRef) {
      this._playerId = playerId;
      this._gameRef = gameRef.child(playerId);
      this._cache = cc.SpriteFrameCache.getInstance();
      this._initIdLabel();
      this._initSprite();
      this._initActions();
      this._setWindowBounds();
      return this._startListening();
    },
    _setWindowBounds: function() {
      var spriteSize, winSize;
      winSize = cc.Director.getInstance().getWinSize();
      spriteSize = this._sprite.getContentSize();
      this._windowBounds["U"] = winSize.height - (spriteSize.height / 2);
      this._windowBounds["D"] = spriteSize.height / 2;
      this._windowBounds["L"] = spriteSize.width / 2;
      return this._windowBounds["R"] = winSize.width - (spriteSize.width / 2);
    },
    _initIdLabel: function() {
      var idLabel, idLabelShadow;
      idLabel = cc.LabelTTF.create(this._playerId, "Arial", 14);
      idLabel.setPosition(0, 40);
      idLabelShadow = cc.LabelTTF.create(this._playerId, "Arial", 14);
      idLabelShadow.setColor(cc.c4(0, 0, 0, 0.3));
      idLabelShadow.setPosition(1, 39);
      this.addChild(idLabelShadow);
      return this.addChild(idLabel);
    },
    _initSprite: function() {
      this._cache.addSpriteFrames(s_ugonoth_plist, s_ugonoth);
      this._stillFrame = this._cache.getSpriteFrame("ugonoth-move-1.png");
      this._sprite = cc.Sprite.createWithSpriteFrame(this._stillFrame);
      return this.addChild(this._sprite);
    },
    _initActions: function() {
      var frames, i, moveAnimation;
      frames = (function() {
        var _i, _results;
        _results = [];
        for (i = _i = 1; _i <= 16; i = ++_i) {
          _results.push(this._cache.getSpriteFrame("ugonoth-move-" + i + ".png"));
        }
        return _results;
      }).call(this);
      moveAnimation = cc.Animation.create(frames, 0.05);
      return this._moveAction = cc.RepeatForever.create(cc.Animate.create(moveAnimation));
    },
    _startListening: function() {
      var _this = this;
      return this._gameRef.on("value", function(snapshot) {
        var update;
        update = snapshot.val();
        _this._updateDirection(update.currentDirection);
        _this._updateSprite();
        return _this.setPosition(update.x, update.y);
      });
    },
    _updateDirection: function(newDirection) {
      if (newDirection === "") {
        if (this._moveActionRunning) {
          this._sprite.stopAction(this._moveAction);
          this._sprite.setDisplayFrame(this._stillFrame);
          return this._moveActionRunning = false;
        }
      } else {
        this._currentDirection = newDirection;
        if (!this._moveActionRunning) {
          this._sprite.runAction(this._moveAction);
          return this._moveActionRunning = true;
        }
      }
    },
    _updateSprite: function() {
      return this._sprite.setRotation(this._rotationForDirection());
    },
    _rotationForDirection: function() {
      switch (this._currentDirection) {
        case "U":
          return 0.0;
        case "D":
          return 180.0;
        case "L":
          return -90.0;
        case "R":
          return 90.0;
        case "UL":
          return -45.0;
        case "UR":
          return 45.0;
        case "DL":
          return -135.0;
        case "DR":
          return 135.0;
        default:
          return 0.0;
      }
    }
  });

  window.Opponent.create = function(playerId, gameRef) {
    var opponent;
    opponent = new Opponent();
    opponent.initWithPlayerIdAndGameRef(playerId, gameRef);
    return opponent;
  };

}).call(this);
