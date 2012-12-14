/*
 Copyright (c) 2012 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
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

            if (MorseUtil.isMorse(inputText))
            {
                // input text is morse code
                output = morseCodeService.codeToString(inputText);
            }
            else
            {
                // input text is alphanumeric text
                output = morseCodeService.stringToCode(inputText);
            }

            model.outputText = output;

            updateOutputSignal.dispatch(output);
        }
    }
}
