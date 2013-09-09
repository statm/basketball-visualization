package statm.dev.basketballvisualization.events
{
    import flash.events.Event;

    import statm.dev.basketballvisualization.analytic.ShotInfo;

    public class ShotEvent extends Event
    {
        public static const SHOT_START:String = "shotStart";

        public static const SHOT_END:String = "shotEnd";

        private var _shotInfo:ShotInfo;

        public function ShotEvent(type:String, shotInfo:ShotInfo)
        {
            super(type);
            this._shotInfo = shotInfo;
        }

        public function get shotInfo():ShotInfo
        {
            return _shotInfo;
        }
    }
}
