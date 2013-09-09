package statm.dev.basketballvisualization.data.entities
{
    public class Ball
    {
        private var posList:Array;

        public function Ball()
        {
            this.posList = new Array();
        }

        public function pushData(frame:int, data:Object):void
        {
            posList[frame] = data;
        }
		
		public function getData(frame:int):Object
		{
			return posList[frame];
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
		
		
		//----------------------------------
		//  validity
		//----------------------------------
		public function get isValid():Boolean
		{
			return !isNaN(x) && !isNaN(y);
		}
		
		
		//----------------------------------
		//  shooting
		//----------------------------------
		private var _isShooting:Boolean = false;
		
		[Bindable]
		public function get isShooting():Boolean
		{
			return _isShooting;
		}
		
		public function set isShooting(value:Boolean):void
		{
			if (value != _isShooting)
			{
				_isShooting = value;
			}
		}
    }
}
