import flash.events.Event;

import statm.dev.basketballvisualization.data.entities.Game;
import statm.dev.basketballvisualization.events.GameEvent;
import statm.dev.basketballvisualization.utils.log;

public static const VERSION:String = "1.3";

[Bindable]
public var game:Game;

private function init():void
{
    log("app init");

    game = new Game("cbg-basketball.json");
    game.addEventListener(GameEvent.READY, currentGame_readyHandler);
    game.loadGame();
}

private function currentGame_readyHandler(event:GameEvent):void
{
    log("game ready");

    gameDisplay.setGame(game);
    playbackUI.setGame(game);
    stage.addEventListener(Event.ENTER_FRAME, stage_enterFrameHandler);
}

private function stage_enterFrameHandler(event:Event):void
{
    game.pulse();
}
