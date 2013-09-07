import flash.events.Event;

import statm.dev.basketballvisualization.data.entities.Game;
import statm.dev.basketballvisualization.events.GameEvent;
import statm.dev.basketballvisualization.utils.log;

public static const VERSION:String = "1.2";

public static var currentGame:Game;

private function init():void
{
    currentGame = new Game("cbg-basketball.json");
    currentGame.addEventListener(GameEvent.READY, currentGame_readyHandler);
    currentGame.loadGame();
}

private function currentGame_readyHandler(event:GameEvent):void
{
    log("game ready");
    gameDisplay.setGame(currentGame);
    stage.addEventListener(Event.ENTER_FRAME, stage_enterFrameHandler);
}

private function stage_enterFrameHandler(event:Event):void
{
    currentGame.playhead += 10;
}
