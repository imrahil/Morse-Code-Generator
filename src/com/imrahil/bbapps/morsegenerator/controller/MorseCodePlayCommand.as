package com.imrahil.bbapps.morsegenerator.controller
{
    import com.imrahil.bbapps.morsegenerator.model.IMorseCodeModel;
    import com.imrahil.bbapps.morsegenerator.services.IMorseCodeService;
    import com.imrahil.bbapps.morsegenerator.signals.signaltons.SwitchRightSideButtonsSignal;
    import com.imrahil.bbapps.morsegenerator.utils.MorseUtil;

    import flash.events.Event;

    import org.robotlegs.mvcs.SignalCommand;

    public class MorseCodePlayCommand extends SignalCommand
    {
        /** INJECTIONS **/
        [Inject]
        public var model:IMorseCodeModel;

        [Inject]
        public var morseCodeService:IMorseCodeService;

        [Inject]
        public var switchRightSideButtonsSignal:SwitchRightSideButtonsSignal;

        override public function execute():void
        {
			if (MorseUtil.isMorse(model.inputText))
			{
                switchRightSideButtonsSignal.dispatch(false);
				return;
			}

			if(morseCodeService.isPlaying)
			{
				morseCodeService.stop();

//				right.playBtn.label = "PLAY";
//
//				footer.longBeepBtn.enabled = true;
//				footer.shortBeepBtn.enabled = true;
			}
			else
			{
//				right.playBtn.label = "STOP";
//
//				footer.longBeepBtn.enabled = false;
//				footer.shortBeepBtn.enabled = false;

				morseCodeService.playString(model.inputText);

                morseCodeService.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);

				this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
        }
    }
}
