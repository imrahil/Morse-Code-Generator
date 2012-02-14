package com.imrahil.bbapps.morsegenerator.controller
{
    import com.imrahil.bbapps.morsegenerator.model.IMorseCodeModel;
    import com.imrahil.bbapps.morsegenerator.services.IMorseCodeService;
    import com.imrahil.bbapps.morsegenerator.signals.signaltons.StartFlickerSignal;
    import com.imrahil.bbapps.morsegenerator.utils.MorseUtil;

    import org.robotlegs.mvcs.SignalCommand;

    public class ComputeFlickerCommand extends SignalCommand
    {
        /** INJECTIONS **/
        [Inject]
        public var model:IMorseCodeModel;

        [Inject]
        public var morseCodeService:IMorseCodeService;

        [Inject]
        public var startFlickerSignal:StartFlickerSignal;

        override public function execute():void
        {
            // do nothing if input string is Morse code
            if (MorseUtil.isMorse(model.inputText))
            {
                return;
            }

            var flickerCodeString:String = morseCodeService.stringToCode(model.inputText);
            var flickerArray:Array = morseCodeService.codeStringToTimes(flickerCodeString);

            startFlickerSignal.dispatch(flickerArray);
        }
    }
}
