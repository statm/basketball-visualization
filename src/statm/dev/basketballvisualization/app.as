import flash.utils.setTimeout;

import statm.dev.basketballvisualization.data.entities.Game;

public static const VERSION:String = "1.0";

public static var currentGame:Game;

private function init():void
{
    currentGame = new Game("cbg-basketball.json");
    currentGame.loadGame();
}
