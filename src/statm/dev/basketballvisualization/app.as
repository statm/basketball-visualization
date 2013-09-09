import flash.events.Event;

import spark.events.IndexChangeEvent;

import statm.dev.basketballvisualization.analytic.AnalyticCore;
import statm.dev.basketballvisualization.data.entities.Game;
import statm.dev.basketballvisualization.events.GameEvent;
import statm.dev.basketballvisualization.utils.log;

public static const VERSION:String = "1.5";

[Bindable]
public var game:Game;

private var analyticCore:AnalyticCore;

private function init():void
{
    log("app init");

    game = new Game("cbg-basketball.json");
    game.addEventListener(GameEvent.READY, game_readyHandler);
    game.addEventListener(GameEvent.LOAD_PROGRESS, game_loadProgressHandler);
    game.loadGame();
}

private function game_loadProgressHandler(event:GameEvent):void
{
    statusLabel.text = "Loading " + game.loadProgress + "%";
}

private function game_readyHandler(event:GameEvent):void
{
    log("game ready");
    currentState = "running";

	analyticCore = new AnalyticCore(game, analyticDisplay);
    gameDisplay.setGame(game);
    playbackUI.setGame(game);
    shotList.dataProvider = game.shotList;

    stage.addEventListener(Event.ENTER_FRAME, stage_enterFrameHandler);
}

private function stage_enterFrameHandler(event:Event):void
{
    game.pulse();
}

private function shotList_changeHanler(event:IndexChangeEvent):void
{
    game.playhead = shotList.selectedItem.fromFrame;
    shotList.selectedIndex = -1;
}
