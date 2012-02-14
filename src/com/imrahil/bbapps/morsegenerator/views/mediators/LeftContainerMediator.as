package com.imrahil.bbapps.morsegenerator.views.mediators
{
    import com.imrahil.bbapps.morsegenerator.signals.SetSpeedSignal;
    import com.imrahil.bbapps.morsegenerator.signals.TranslateSignal;
    import com.imrahil.bbapps.morsegenerator.signals.signaltons.SwitchRightSideButtonsSignal;
    import com.imrahil.bbapps.morsegenerator.utils.LogUtil;
    import com.imrahil.bbapps.morsegenerator.views.LeftContainer;

    import mx.logging.ILogger;

    import org.robotlegs.mvcs.Mediator;

    import qnx.system.AudioManager;
    import qnx.system.AudioOutput;

    public class LeftContainerMediator extends Mediator
    {
        [Inject]
        public var view:LeftContainer;

        [Inject]
        public var translateSignal:TranslateSignal;

        [Inject]
        public var setSpeedSignal:SetSpeedSignal;

        [Inject]
        public var switchRightSideButtonsSignal:SwitchRightSideButtonsSignal;

        /** variables **/
        private var logger:ILogger;

        public function LeftContainerMediator()
        {
            super();

            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        override public function onRegister():void
        {
            logger.debug(": onRegister");

            CONFIG::device
            {
                view.volumeSlider.value = AudioManager.audioManager.getOutputLevel(AudioOutput.SPEAKERS);
            }

            view.inputTextChangeSignal.add(onInputTextChanged);
            view.translateBtnClickSignal.add(onTranslateBtnClicked);
            view.volumeSliderSignal.add(onVolumeSliderMoved);
            view.speedSliderSignal.add(onSpeedSliderMoved);
        }

        private function onInputTextChanged(inputText:String):void
        {
            logger.info("onInputTextChanged");

            if (view.translateBtn.enabled)
            {
                return;
            }

            if (inputText == "")
            {
                switchRightSideButtonsSignal.dispatch(false);
            }
            else
            {
                switchRightSideButtonsSignal.dispatch(true);
            }

            translateSignal.dispatch(inputText);
        }

        private function onTranslateBtnClicked(inputText:String):void
        {
            logger.info("onTranslateBtnClicked");

            translateSignal.dispatch(inputText);
        }

        private function onVolumeSliderMoved(volume:Number):void
        {
            CONFIG::device
            {
                AudioManager.audioManager.setOutputLevel(volume, AudioOutput.SPEAKERS);
            }
        }

        private function onSpeedSliderMoved(newSpeed:int):void
        {
            view.speedSlider.value = newSpeed;
            setSpeedSignal.dispatch(newSpeed);
        }
    }
}
