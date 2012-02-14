package com.imrahil.bbapps.morsegenerator.model
{
    import com.imrahil.bbapps.morsegenerator.utils.LogUtil;

    import mx.logging.ILogger;

    import org.robotlegs.mvcs.Actor;

    public class MorseCodeModel extends Actor implements IMorseCodeModel
    {
        private var logger:ILogger;

        private var _inputText:String = "";

        public function MorseCodeModel()
        {
            super();

            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        public function set inputText(newText:String):void
        {
            _inputText = newText;
        }

        public function get inputText():String
        {
            return _inputText;
        }
    }
}
