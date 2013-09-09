package statm.dev.basketballvisualization.utils
{
    import flash.display.BitmapData;
    import flash.display.Graphics;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    import statm.dev.basketballvisualization.analytic.ShotInfo;
    import statm.dev.basketballvisualization.data.entities.Ball;
    import statm.dev.basketballvisualization.data.entities.Game;
    import statm.dev.basketballvisualization.data.entities.Player;
    import statm.dev.basketballvisualization.data.entities.PlayerType;

    public class AnalyticUtils
    {
        public static function generateTimeoutMap(game:Game):BitmapData
        {
            var result:BitmapData = new BitmapData(798, 18, true, 0x00FFFFFF);

            var timeoutList:Vector.<int> = game.getTimeoutFrameList();

            for (var i:int = 0; i < timeoutList.length; i += 2)
            {
                result.fillRect(new Rectangle(timeoutList[i] / game.totalFrame * 798, 0, (timeoutList[i + 1] - timeoutList[i]) / game.totalFrame * 798, 18), 0xFFCC0000);
            }

            return result;
        }

        public static function getShotInfo(game:Game, frame:int):ShotInfo
        {
            var result:ShotInfo;

            var ball:Ball = game.getBall();

            var pos:Object = ball.getData(frame);
            var lastPos:Object = ball.getData(frame - 1);
            var nextPos:Object = ball.getData(frame + 1);

            if (!pos || !lastPos || !nextPos)
            {
                return null;
            }

            if (pos[2] > 10 && lastPos[2] < pos[2] && nextPos[2] < pos[2])
            {
//                log("max z: " + pos[2]);

                var tryingFrame:int = frame;
                while (ball.getData(tryingFrame) && ball.getData(tryingFrame)[2] > 10)
                {
                    tryingFrame--;
                }

                var target:Point = new Point(pos[0] * 2 - ball.getData(tryingFrame)[0], pos[1] * 2 - ball.getData(tryingFrame)[1]);

                var dist:Number;
                var shooterType:int;

                if (target.x < 47)
                {
                    dist = Point.distance(Constants.BASKET_POS_HOME, target);
                    shooterType = PlayerType.AWAY;
                }
                else
                {
                    dist = Point.distance(Constants.BASKET_POS_AWAY, target);
                    shooterType = PlayerType.HOME;
                }

//                log("dist: " + dist);

                if (dist < Constants.SHOT_RANGE_RADIUS)
                {
                    result = new ShotInfo();
                    result.target = target;
                    result.toFrame = 2 * frame - tryingFrame;

                    while (ball.getData(tryingFrame - 1)
                        && ball.getData(tryingFrame - 1)[2] < ball.getData(tryingFrame)[2])
                    {
                        tryingFrame--;
                    }

                    result.fromFrame = tryingFrame;
                    result.shooter = getNearestPlayer(game, tryingFrame, shooterType);
                    result.shooterPos = new Point(result.shooter.getData(tryingFrame)[0], result.shooter.getData(tryingFrame)[1]);
					result.gameClock = game.frameToGameClock(tryingFrame);
//                    log("shot: " + result.fromFrame + " -> " + result.toFrame + " (" + (result.toFrame - result.fromFrame) + " frames)");
                }
            }

            return result;
        }

        public static function getNearestPlayer(game:Game, frame:int, type:int):Player
        {
            var ballPos:Object = game.getBall().getData(frame);
            var result:Player;
            var nearestDist:Number = Number.MAX_VALUE;

            for (var i:int = 0; i < 5; i++)
            {
                var player:Player = game.getPlayer(i, type, frame);
                var pos:Object = player.getData(frame);
                var dist:Number = Point.distance(new Point(pos[0], pos[1]), new Point(ballPos[0], ballPos[1]));
                if (dist < nearestDist)
                {
                    nearestDist = dist;
                    result = player;
                }
            }

            return result;
        }

        public static function drawShotInfo(shotInfo:ShotInfo, graphics:Graphics):void
        {
            var target:Point = shotInfo.target;

            var color:int = int(Math.random() * 0xFFFFFF);

            graphics.beginFill(color);
            graphics.drawCircle(target.x * Constants.MAGNIFY_RATIO, target.y * Constants.MAGNIFY_RATIO, 6);
            graphics.endFill();

            graphics.beginFill(color);
            graphics.drawCircle(shotInfo.shooterPos.x * Constants.MAGNIFY_RATIO,
                                shotInfo.shooterPos.y * Constants.MAGNIFY_RATIO, 10);
            graphics.endFill();

            graphics.lineStyle(1, color);
            graphics.moveTo(target.x * Constants.MAGNIFY_RATIO, target.y * Constants.MAGNIFY_RATIO);
            graphics.lineTo(shotInfo.shooterPos.x * Constants.MAGNIFY_RATIO,
                            shotInfo.shooterPos.y * Constants.MAGNIFY_RATIO);
            graphics.lineStyle();
        }
    }
}
