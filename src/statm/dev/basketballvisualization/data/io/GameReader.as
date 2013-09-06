package statm.dev.basketballvisualization.data.io
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.ProgressEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;

    import statm.dev.basketballvisualization.events.GameReaderEvent;

    [Event(name = "progress", type = "statm.dev.basketballvisualization.events.GameReaderEvent")]
    [Event(name = "complete", type = "statm.dev.basketballvisualization.events.GameReaderEvent")]

    public class GameReader extends EventDispatcher
    {
        private var dataURL:String;
        private var loader:URLLoader;
        private var progress:Number = 0.0;
        private var entries:Array;

        public function GameReader(dataURL:String)
        {
            this.dataURL = dataURL;
            loader = new URLLoader();
            loader.addEventListener(Event.COMPLETE, loader_completeHandler);
            loader.addEventListener(ProgressEvent.PROGRESS, loader_progressHandler);
        }

        public function read():void
        {
            loader.load(new URLRequest(dataURL));
        }

        private function loader_completeHandler(event:Event):void
        {
			entries = loader.data.split("\n");
            this.dispatchEvent(new GameReaderEvent(GameReaderEvent.COMPLETE));
        }

        private function loader_progressHandler(event:ProgressEvent):void
        {
            this.progress = event.bytesLoaded / event.bytesTotal;
            this.dispatchEvent(new GameReaderEvent(GameReaderEvent.PROGRESS));
        }

        public function getProgress():Number
        {
            return progress;
        }

        public function getEntries():Array
        {
            return entries;
        }
    }
}
