package statm.dev.basketballvisualization.data.entities
{

    public class Player
    {
        private var _id:int;
        private var posList:Array;

        public function Player(id:int)
        {
            this._id = id;
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
        //  id
        //----------------------------------
        public function get id():int
        {
            return _id;
        }


        //----------------------------------
        //  x
        //----------------------------------
        private var _x:Number = NaN;

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
        private var _y:Number = NaN;

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
        //  type
        //----------------------------------
        private var _type:int;

        [Bindable]
        public function get type():int
        {
            return _type;
        }

        internal function set type(value:int):void
        {
            _type = value;
        }


        //----------------------------------
        //  update
        //----------------------------------
        public function update(frame:int):Boolean
        {
            var dirty:Boolean;

            if (posList[frame])
            {
                dirty = isNaN(x);
                x = posList[frame][0];
                y = posList[frame][1];
            }
            else
            {
                dirty = !isNaN(x);
                x = NaN;
                y = NaN;
            }

            return dirty;
        }


        //----------------------------------
        //  validity
        //----------------------------------
        public function isValid(frame:int):Boolean
        {
            return posList[frame] != null;
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
