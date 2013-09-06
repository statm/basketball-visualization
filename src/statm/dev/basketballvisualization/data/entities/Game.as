package statm.dev.basketballvisualization.data.entities
{
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;
    import flash.utils.setInterval;
    import flash.utils.setTimeout;
    
    import mx.core.FlexGlobals;
    
    import statm.dev.basketballvisualization.data.io.GameReader;
    import statm.dev.basketballvisualization.events.GameReaderEvent;
    import statm.dev.basketballvisualization.utils.log;

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

        internal var startTime:Number = -1;

        private function initData():void
        {
            players = new Vector.<Player>();
            playerDic = new Dictionary();
            ball = new Ball();
			referees = new Vector.<Referee>();
			refDic = new Dictionary();
        }


        //----------------------------------
        //  loading
        //----------------------------------
        private var reader:GameReader;

        private function initReader():void
        {
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
            log("load complete");

            parseEntries(reader.getEntries());
            log("parse complete");

            FlexGlobals.topLevelApplication.gameDisplay.player0.setPlayer(players[0]);
            FlexGlobals.topLevelApplication.gameDisplay.player1.setPlayer(players[1]);
            FlexGlobals.topLevelApplication.gameDisplay.player2.setPlayer(players[2]);
            FlexGlobals.topLevelApplication.gameDisplay.player3.setPlayer(players[3]);
            FlexGlobals.topLevelApplication.gameDisplay.player4.setPlayer(players[4]);
            FlexGlobals.topLevelApplication.gameDisplay.player5.setPlayer(players[5]);
            FlexGlobals.topLevelApplication.gameDisplay.player6.setPlayer(players[6]);
            FlexGlobals.topLevelApplication.gameDisplay.player7.setPlayer(players[7]);
            FlexGlobals.topLevelApplication.gameDisplay.player8.setPlayer(players[8]);
            FlexGlobals.topLevelApplication.gameDisplay.player9.setPlayer(players[9]);
            FlexGlobals.topLevelApplication.gameDisplay.ball.setBall(ball);
            FlexGlobals.topLevelApplication.gameDisplay.ref0.setReferee(referees[0]);
            FlexGlobals.topLevelApplication.gameDisplay.ref1.setReferee(referees[1]);
            FlexGlobals.topLevelApplication.gameDisplay.ref2.setReferee(referees[2]);
			
            play();
        }


        //----------------------------------
        //  parsing
        //----------------------------------
        private function parseEntries(entries:Array):void
        {
            var entryObj:Object;
            var frame:int;
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
            }
        }


        //----------------------------------
        //  playback
        //----------------------------------
        private var playhead:int;

        public function play():void
        {
            playhead = 0;
            setInterval(updateGameObjects, 40);
        }

        private function updateGameObjects():void
        {
            playhead += 5;

            for each (var player:Player in players)
            {
                player.update(playhead);
            }

            ball.update(playhead);
			
			for each (var ref:Referee in referees)
			{
				ref.update(playhead);
			}
        }
    }
}
