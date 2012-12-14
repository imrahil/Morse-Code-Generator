/*
 Copyright (c) 2012 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
package com.imrahil.bbapps.morsegenerator.services
{
    import flash.utils.ByteArray;

    import org.osflash.signals.Signal;

    public interface IMorseCodeService
    {
        function set speed(speed:Number):void;
        function get speed():Number;

        function get isPlaying():Boolean;

        function get soundCompleteSignal():Signal;

        function playString(morseCode:String):void;

        function stop():void;

        function stringToCode(value:String):String;

        function codeToString(code:String):String;

        function codeStringToTimes(value:String):Array;

        function saveAsWav(morseCode:String):ByteArray;
    }
}
