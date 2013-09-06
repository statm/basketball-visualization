package statm.dev.basketballvisualization.utils
{
    import flash.system.System;
    import flash.utils.getTimer;

    public function log(logContent:*):void
    {
        var time:int = getTimer();
        trace("[" + (time / 1000).toFixed(3) + "s, " + Number(System.totalMemory / 1024 / 1024).toFixed(2) + "M] " + logContent.toString());
    }
}
