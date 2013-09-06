package statm.dev.basketballvisualization.events
{
    import flash.events.Event;

    public class GameReaderEvent extends Event
    {
		public static const PROGRESS:String = "progress";
		
        public static const COMPLETE:String = "complete";

        public function GameReaderEvent(type:String)
        {
            super(type);
        }
    }
}
