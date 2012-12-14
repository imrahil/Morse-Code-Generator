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
    import com.imrahil.bbapps.morsegenerator.signals.signaltons.SwitchMorseCodePlaySignal;
    import com.imrahil.bbapps.morsegenerator.utils.MorseUtil;

    import org.robotlegs.mvcs.SignalCommand;

    public class MorseCodePlayCommand extends SignalCommand
    {
        /** INJECTIONS **/
        [Inject]
        public var model:IMorseCodeModel;

        [Inject]
        public var morseCodeService:IMorseCodeService;

        [Inject]
        public var switchMorseCodePlaySignal:SwitchMorseCodePlaySignal;

        override public function execute():void
        {
            if (MorseUtil.isMorse(model.outputText))
            {
                if (morseCodeService.isPlaying)
                {
                    switchMorseCodePlaySignal.dispatch(false);

                    morseCodeService.stop();
                }
                else
                {
                    switchMorseCodePlaySignal.dispatch(true);

                    morseCodeService.playString(model.outputText);
                    morseCodeService.soundCompleteSignal.addOnce(onSoundComplete);
                }
            }
        }

        private function onSoundComplete():void
        {
            switchMorseCodePlaySignal.dispatch(false);
        }
    }
}
