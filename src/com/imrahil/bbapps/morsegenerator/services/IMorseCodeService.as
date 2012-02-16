package com.imrahil.bbapps.morsegenerator.services
{
    import org.osflash.signals.Signal;

    public interface IMorseCodeService
    {
        function playString(string:String):void;
        function stop():void;

        function stringToCode(value:String):String;
        function codeToString(code:String):String;
        function codeStringToTimes(value:String):Array;

        function set speed(speed:Number):void;
        function get isPlaying():Boolean;

        function get soundCompleteSignal():Signal;
    }
}
