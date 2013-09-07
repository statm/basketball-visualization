package statm.dev.basketballvisualization.utils
{
    import flash.display.BitmapData;
    import flash.geom.Rectangle;

    import statm.dev.basketballvisualization.data.entities.Game;

    public class VisualizationUtils
    {
        public static function generateTimeoutMap(game:Game):BitmapData
        {
            var result:BitmapData = new BitmapData(868, 18, true, 0x00FFFFFF);

            var timeoutList:Vector.<int> = game.getTimeoutFrameList();

            for (var i:int = 0; i < timeoutList.length; i += 2)
            {
                result.fillRect(new Rectangle(timeoutList[i] / game.totalFrame * 868, 0, (timeoutList[i + 1] - timeoutList[i]) / game.totalFrame * 868, 18), 0xFFFF0000);
            }

            return result;
        }
    }
}
