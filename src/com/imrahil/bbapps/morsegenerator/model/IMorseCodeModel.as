/*
 Copyright (c) 2013 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
package com.imrahil.bbapps.morsegenerator.model
{
    public interface IMorseCodeModel
    {
        function get inputText():String;
        function set inputText(value:String):void;

        function get outputText():String;
        function set outputText(value:String):void;

        function get purchaseStatus():int;
        function set purchaseStatus(value:int):void;
    }
}
