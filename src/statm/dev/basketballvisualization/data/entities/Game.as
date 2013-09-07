package statm.dev.basketballvisualization.data.entities
{
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;

    import statm.dev.basketballvisualization.data.io.GameReader;
    import statm.dev.basketballvisualization.events.GameEvent;
    import statm.dev.basketballvisualization.events.GameReaderEvent;
    import statm.dev.basketballvisualization.utils.log;

    [Event(name = "ready", type = "statm.dev.basketballvisualization.events.GameEvent")]
    [Event(name = "update", type = "statm.dev.basketballvisualization.events.GameEvent")]
    [Event(name = "play", type = "statm.dev.basketballvisualization.events.GameEvent")]
    [Event(name = "stop", type = "statm.dev.basketballvisualization.events.GameEvent")]
    [Event(name = "scrubStart", type = "statm.dev.basketballvisualization.events.GameEvent")]
    [Event(name = "scrubEnd", type = "statm.dev.basketballvisualization.events.GameEvent")]

    public class Game extends EventDispatcher
    {
        private var dataURL:String;

        public function Game(dataURL:String)
        {
            this.dataURL = dataURL;
            initReader();
            initData();
        }


        //----------------------------------
        //  data
        //----------------------------------
        private var players:Vector.<Player>;
        private var playerDic:Dictionary;
        private var ball:Ball;
        private var referees:Vector.<Referee>;
        private var refDic:Dictionary;
        private var gameClockList:Array;
        private var timeoutFrameList:Vector.<int>;

        private function initData():void
        {
            players = new Vector.<Player>();
            playerDic = new Dictionary();
            ball = new Ball();
            referees = new Vector.<Referee>();
            refDic = new Dictionary();
            gameClockList = new Array();
            timeoutFrameList = new Vector.<int>();
        }

        public function getPlayer(index:int, type:int):Player
        {
            var currentIndex:int = 0;

            for each (var player:Player in players)
            {
                if (player.isValid && player.type == type)
                {
                    if (currentIndex == index)
                    {
                        return player;
                    }
                    else
                    {
                        currentIndex++;
                    }
                }
            }

            return null;
        }

        public function getReferee(index:int):Referee
        {
            var currentIndex:int = 0;

            for each (var ref:Referee in referees)
            {
                if (ref.isValid)
                {
                    if (currentIndex == index)
                    {
                        return ref;
                    }
                    else
                    {
                        currentIndex++;
                    }
                }
            }

            return null;
        }

        public function getBall():Ball
        {
            return ball;
        }

        public function getTimeoutFrameList():Vector.<int>
        {
            return timeoutFrameList;
        }


        //----------------------------------
        //  game clock
        //----------------------------------
        private var _gameClock:Number = 0;

        [Bindable]
        public function get gameClock():Number
        {
            return _gameClock;
        }

        private function set gameClock(value:Number):void
        {
            _gameClock = value;
        }


        //----------------------------------
        //  loading
        //----------------------------------
        private var _isReady:Boolean = false;

        public function get isReady():Boolean
        {
            return _isReady;
        }

        private var reader:GameReader;

        private function initReader():void
        {
            _isReady = false;

            reader = new GameReader(dataURL);
            reader.addEventListener(GameReaderEvent.PROGRESS, reader_progressHandler);
            reader.addEventListener(GameReaderEvent.COMPLETE, reader_completeHandler);
        }

        public function loadGame():void
        {
            reader.read();
        }

        private function reader_progressHandler(event:GameReaderEvent):void
        {
//            log("loading: " + int(reader.getProgress() * 100) + "%");
        }

        private function reader_completeHandler(event:GameReaderEvent):void
        {
            parseEntries(reader.getEntries());
            _isReady = true;
            this.dispatchEvent(new GameEvent(GameEvent.READY));
        }


        //----------------------------------
        //  parsing
        //----------------------------------
        private function parseEntries(entries:Array):void
        {
            var entryObj:Object;
            var frame:int;
            var lastSavedFrame:int = 0;
            var playerObj:Object;
            var player:Player;
            var refObj:Object;
            var referee:Referee;

            for each (var entry:String in entries)
            {
                entryObj = JSON.parse(entry);

                if (startTime == -1)
                {
                    startTime = entryObj.time;
                }

                frame = (entryObj.time - startTime) / 40;

                // timeouts
                if (frame - lastSavedFrame > 1)
                {
                    timeoutFrameList.push(lastSavedFrame, frame);
                }
                lastSavedFrame = frame;

                // home players
                for each (playerObj in entryObj.home)
                {
                    if (!playerDic[playerObj[1]])
                    {
                        player = new Player(playerObj[1]);
                        player.type = PlayerType.HOME;
                        playerDic[playerObj[1]] = player;
                        players.push(player);
                    }

                    playerDic[playerObj[1]].pushData(frame, playerObj[0]);
                }

                // away players
                for each (playerObj in entryObj.away)
                {
                    if (!playerDic[playerObj[1]])
                    {
                        player = new Player(playerObj[1]);
                        player.type = PlayerType.AWAY;
                        playerDic[playerObj[1]] = player;
                        players.push(player);
                    }

                    playerDic[playerObj[1]].pushData(frame, playerObj[0]);
                }

                // ball
                ball.pushData(frame, entryObj.ball);

                // referees
                for each (refObj in entryObj.refs)
                {
                    if (!refDic[refObj[1]])
                    {
                        referee = new Referee(refObj[1]);
                        refDic[refObj[1]] = referee;
                        referees.push(referee);
                    }

                    refDic[refObj[1]].pushData(frame, refObj[0]);
                }

                // game clock
                gameClockList[frame] = entryObj.game_clock;
            }

            endTime = entryObj.time;
            totalFrame = frame;

            playhead = 0;
        }


        //----------------------------------
        //  update
        //----------------------------------
        private function updateGameObjects():void
        {
            _redrawNeeded = false;

            for each (var player:Player in players)
            {
                _redrawNeeded = player.update(playhead) || _redrawNeeded;
            }

            ball.update(playhead);

            for each (var ref:Referee in referees)
            {
                ref.update(playhead);
            }

            this.dispatchEvent(new GameEvent(GameEvent.UPDATE));
        }


        //----------------------------------
        //  redrawNeeded
        //----------------------------------
        private var _redrawNeeded:Boolean = false;

        public function get redrawNeeded():Boolean
        {
            return _redrawNeeded;
        }


        //----------------------------------
        //  playback props
        //----------------------------------
        private var _startTime:Number = -1;

        [Bindable]
        public function get startTime():Number
        {
            return _startTime;
        }

        private function set startTime(value:Number):void
        {
            _startTime = value;
        }

        private var _endTime:Number = -1;

        [Bindable]
        public function get endTime():Number
        {
            return _endTime;
        }

        private function set endTime(value:Number):void
        {
            _endTime = value;
        }

        private var _totalFrame:int = 0;

        [Bindable]
        public function get totalFrame():int
        {
            return _totalFrame;
        }

        private function set totalFrame(value:int):void
        {
            _totalFrame = value;
        }

        private var _playhead:int = -1;

        [Bindable]
        public function get playhead():int
        {
            return _playhead;
        }

        public function set playhead(value:int):void
        {
            _playhead = value;

            if (_playhead > _totalFrame)
            {
                _playhead = 0;
                stop();
            }

            if (!isNaN(gameClock) && !gameClockList[playhead])
            {
                log("timeout");
            }

            if (isNaN(gameClock) && gameClockList[playhead])
            {
                log("timeout over");
            }

            gameClock = gameClockList[playhead];

            updateGameObjects();
        }

        public function isTimeout(frame:int = -1):Boolean
        {
            (frame == -1) && (frame = playhead);
            return (gameClockList[frame] == null);
        }


        //----------------------------------
        //  playback control
        //----------------------------------
        private var _isPlaying:Boolean = false;

        [Bindable]
        public function get isPlaying():Boolean
        {
            return _isPlaying;
        }

        private function set isPlaying(value:Boolean):void
        {
            _isPlaying = value;
        }

        private var _speed:int = 1;

        private var _isScrubbing:Boolean = false;

        public function pulse():void
        {
            if (_isPlaying && !_isScrubbing)
            {
                playhead += _speed;
            }
        }

        public function play(speed:int = 1):void
        {
            if (!_isReady || _isScrubbing)
            {
                return;
            }

            _speed = speed;
            isPlaying = true;
        }

        public function stop():void
        {
            isPlaying = false;
        }

        public function startScrub():void
        {
            _isScrubbing = true;
        }

        public function stopScrub():void
        {
            _isScrubbing = false;
        }
    }
}
