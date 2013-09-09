package statm.dev.basketballvisualization.analytic
{
    import flash.geom.Point;

    import statm.dev.basketballvisualization.data.entities.Player;
    import statm.dev.basketballvisualization.utils.StringUtils;

    public class ShotInfo
    {
        public var target:Point;

        public var shooter:Player;

        public var shooterPos:Point;

        public var fromFrame:int;

        public var toFrame:int;

        public var gameClock:Number;

        public function toString():String
        {
            return "T: " + StringUtils.formatGameClock(gameClock) + "     Player: " + shooter.id;
        }
    }
}
