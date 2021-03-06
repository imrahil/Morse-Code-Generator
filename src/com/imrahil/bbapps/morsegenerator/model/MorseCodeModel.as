/*
 Copyright (c) 2013 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
package com.imrahil.bbapps.morsegenerator.model
{
    import com.imrahil.bbapps.morsegenerator.constants.ApplicationConstants;

    import org.robotlegs.mvcs.Actor;

    public class MorseCodeModel extends Actor implements IMorseCodeModel
    {
        private var _inputText:String = "";
        private var _outputText:String = "";
        private var _purchaseStatus:int = ApplicationConstants.PURCHASE_SUBSCRIPTION_UNKNOWN;

        public function get inputText():String
        {
            return _inputText;
        }

        public function set inputText(value:String):void
        {
            _inputText = value;
        }

        public function get outputText():String
        {
            return _outputText;
        }

        public function set outputText(value:String):void
        {
            _outputText = value;
        }

        public function get purchaseStatus():int
        {
            return _purchaseStatus;
        }

        public function set purchaseStatus(value:int):void
        {
            _purchaseStatus = value;
        }
    }
}
