package statm.dev.basketballvisualization.events
{
    import flash.events.Event;

    public class GameEvent extends Event
    {
        public static const READY:String = "ready";

        public static const UPDATE:String = "update";

        public function GameEvent(type:String)
        {
            super(type);
        }
    }
}
