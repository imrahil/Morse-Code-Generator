package com.imrahil.bbapps.morsegenerator.model
{
    import com.imrahil.bbapps.morsegenerator.utils.LogUtil;

    import mx.logging.ILogger;

    import org.robotlegs.mvcs.Actor;

    public class MorseCodeModel extends Actor implements IMorseCodeModel
    {
        private var logger:ILogger;

        private var _inputText:String = "";
        private var _outputText:String = "";

        public function MorseCodeModel()
        {
            super();

            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

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
    }
}
