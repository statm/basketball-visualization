package statm.dev.basketballvisualization.analytic
{
    import spark.components.Group;
    
    import statm.dev.basketballvisualization.data.entities.Game;
    import statm.dev.basketballvisualization.events.GameEvent;
    import statm.dev.basketballvisualization.utils.AnalyticUtils;
    import statm.dev.basketballvisualization.utils.log;

    public class AnalyticCore
    {
        private var game:Game;
        private var display:Group;

        public function AnalyticCore(game:Game, display:Group)
        {
            this.game = game;
            this.display = display;

            if (game.isReady)
            {
                analyzeShots();
            }
            else
            {
                game.addEventListener(GameEvent.READY, game_readyHandler);
            }
        }

        private function game_readyHandler(event:GameEvent):void
        {
            analyzeShots();
        }
		
        private function analyzeShots():void
        {
            var l:int = game.totalFrame;
            for (var i:int = 0; i < l; i++)
            {
				var shotInfo:ShotInfo = AnalyticUtils.getShotInfo(game, i);
				if (shotInfo)
				{
					i = shotInfo.toFrame;
					AnalyticUtils.drawShotInfo(shotInfo, display.graphics);
					game.shotList.addItem(shotInfo);
				}
            }
            log("analyze complete");
        }
    }
}
