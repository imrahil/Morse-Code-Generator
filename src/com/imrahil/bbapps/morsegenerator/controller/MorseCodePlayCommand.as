package com.imrahil.bbapps.morsegenerator.controller
{
    import com.imrahil.bbapps.morsegenerator.model.IMorseCodeModel;
    import com.imrahil.bbapps.morsegenerator.services.IMorseCodeService;
    import com.imrahil.bbapps.morsegenerator.signals.signaltons.SwitchFooterButtonsSignal;
    import com.imrahil.bbapps.morsegenerator.signals.signaltons.SwitchMorseCodePlaySignal;

    import org.robotlegs.mvcs.SignalCommand;

    public class MorseCodePlayCommand extends SignalCommand
    {
        /** INJECTIONS **/
        [Inject]
        public var model:IMorseCodeModel;

        [Inject]
        public var morseCodeService:IMorseCodeService;

        [Inject]
        public var switchFooterButtonsSignal:SwitchFooterButtonsSignal;

        [Inject]
        public var switchMorseCodePlaySignal:SwitchMorseCodePlaySignal;

        override public function execute():void
        {
//			if (MorseUtil.isMorse(model.inputText))
//			{
//                switchRightSideButtonsSignal.dispatch(false);
//				return;
//			}

			if(morseCodeService.isPlaying)
			{
                switchFooterButtonsSignal.dispatch(true);
                switchMorseCodePlaySignal.dispatch(false);

                morseCodeService.stop();
            }
			else
			{
                switchFooterButtonsSignal.dispatch(false);
                switchMorseCodePlaySignal.dispatch(true);

				morseCodeService.playString(model.inputText);
                morseCodeService.soundCompleteSignal.add(onSoundComplete);
			}
        }

        private function onSoundComplete():void
        {
            switchMorseCodePlaySignal.dispatch(false);
            switchFooterButtonsSignal.dispatch(true);
        }
    }
}
