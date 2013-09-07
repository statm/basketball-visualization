package statm.dev.basketballvisualization.events
{
    import flash.events.Event;

    public class GameEvent extends Event
    {
        public static const READY:String = "ready";

        public static const UPDATE:String = "update";

        public static const PLAY:String = "play";

        public static const STOP:String = "stop";

        public static const SCRUB_START:String = "scrubStart";

        public static const SCRUB_END:String = "scrubEnd";

        public function GameEvent(type:String)
        {
            super(type);
        }
    }
}
