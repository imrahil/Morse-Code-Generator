package com.imrahil.bbapps.morsegenerator.controller
{
    import com.imrahil.bbapps.morsegenerator.model.IMorseCodeModel;
    import com.imrahil.bbapps.morsegenerator.services.IMorseCodeService;
    import com.imrahil.bbapps.morsegenerator.signals.signaltons.UpdateOutputSignal;
    import com.imrahil.bbapps.morsegenerator.utils.MorseUtil;

    import org.robotlegs.mvcs.SignalCommand;

    public class TranslateCommand extends SignalCommand
    {
        /** PARAMETERS **/
        [Inject]
        public var inputText:String;

        /** INJECTIONS **/
        [Inject]
        public var model:IMorseCodeModel;

        [Inject]
        public var morseCodeService:IMorseCodeService;

        [Inject]
        public var updateOutputSignal:UpdateOutputSignal;

        override public function execute():void
        {
            model.inputText = inputText;

            var output:String = "";
            
            if (!MorseUtil.isMorse(inputText))
            {
                output = morseCodeService.stringToCode(inputText);
            }
            else
            {
                output = morseCodeService.codeToString(inputText);
            }
            
            updateOutputSignal.dispatch(output);
        }
    }
}
