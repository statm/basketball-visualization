package statm.dev.basketballvisualization.utils
{
    public class StringUtils
    {
        public static function formatGameClock(gameClock:Number):String
        {
            return leftPad(int(gameClock / 60).toString(), 2, "0") + ":" + leftPad((gameClock % 60).toFixed(1), 4, "0");
        }

        public static function leftPad(str:String, len:int, padChar:String):String
        {
            var result:String = str;

            while (result.length < len)
            {
                result = padChar + result;
            }

            return result;
        }
    }
}
