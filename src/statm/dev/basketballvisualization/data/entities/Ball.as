package statm.dev.basketballvisualization.data.entities
{
    public class Ball
    {
        private var posList:Array;

        public function Ball()
        {
            this.posList = new Array();
        }

        public function pushData(time:int, data:Object):void
        {
            posList[time] = data;
        }

        //----------------------------------
        //  x
        //----------------------------------
        private var _x:Number;

        [Bindable]
        public function get x():Number
        {
            return _x;
        }
		
		private function set x(value:Number):void
		{
			_x = value;
		}


        //----------------------------------
        //  y
        //----------------------------------
        private var _y:Number;

        [Bindable]
        public function get y():Number
        {
            return _y;
        }
		
		public function set y(value:Number):void
		{
			_y = value;
		}


        //----------------------------------
        //  z
        //----------------------------------
        private var _z:Number;

        [Bindable]
        public function get z():Number
        {
            return _z;
        }
		
		public function set z(value:Number):void
		{
			_z = value;
		}


        //----------------------------------
        //  update
        //----------------------------------
        public function update(frame:int):void
        {
            if (posList[frame])
            {
                x = posList[frame][0];
                y = posList[frame][1];
                z = posList[frame][2];
            }
            else
            {
                x = NaN;
                y = NaN;
                z = NaN;
            }
        }
    }
}
