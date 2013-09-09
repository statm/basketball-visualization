package statm.dev.basketballvisualization.data.entities
{
	public class Referee
	{
		private var id:int;
		private var posList:Array;
		
		public function Referee(id:int)
		{
			this.id = id;
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
		
		private function set y(value:Number):void
		{
			_y = value;
		}
		
		
		//----------------------------------
		//  update
		//----------------------------------
		public function update(time:int):void
		{
			if (posList[time])
			{
				x = posList[time][0];
				y = posList[time][1];
			}
			else
			{
				x = NaN;
				y = NaN;
			}
		}
		
		
		//----------------------------------
		//  validity
		//----------------------------------
		public function get isValid():Boolean
		{
			return !isNaN(x) && !isNaN(y);
		}
	}
}


