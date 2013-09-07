import flash.events.Event;

import statm.dev.basketballvisualization.data.entities.Game;

public static const VERSION:String = "1.1";

public static var currentGame:Game;

private function init():void
{
    currentGame = new Game("cbg-basketball.json");
    currentGame.loadGame();
	
	stage.addEventListener(Event.ENTER_FRAME, stage_enterFrameHandler);
}

private function stage_enterFrameHandler(event:Event):void
{
	currentGame.pulse();
}
