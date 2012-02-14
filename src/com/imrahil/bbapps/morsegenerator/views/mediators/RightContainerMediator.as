package com.imrahil.bbapps.morsegenerator.views.mediators
{
    import com.imrahil.bbapps.morsegenerator.services.IMorseCodeService;
    import com.imrahil.bbapps.morsegenerator.signals.ComputeFlickerSignal;
    import com.imrahil.bbapps.morsegenerator.signals.signaltons.SwitchRightSideButtonsSignal;
    import com.imrahil.bbapps.morsegenerator.signals.signaltons.UpdateOutputSignal;
    import com.imrahil.bbapps.morsegenerator.utils.LogUtil;
    import com.imrahil.bbapps.morsegenerator.views.RightContainer;

    import flash.events.Event;
    import flash.media.SoundMixer;
    import flash.utils.ByteArray;

    import mx.logging.ILogger;

    import org.robotlegs.mvcs.Mediator;

    public class RightContainerMediator extends Mediator
    {
        [Inject]
        public var view:RightContainer;

        [Inject]
        public var morseCodeService:IMorseCodeService;

        [Inject]
        public var computeFlickerSignal:ComputeFlickerSignal;

        [Inject]
        public var updateOutputSignal:UpdateOutputSignal;

        [Inject]
        public var switchRightSideButtonsSignal:SwitchRightSideButtonsSignal;


        /** variables **/
        private var logger:ILogger;

        public function RightContainerMediator()
        {
            super();

            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        override public function onRegister():void
        {
            logger.debug(": onRegister");

            updateOutputSignal.add(onUpdateSignal);
            switchRightSideButtonsSignal.add(onSwitchButtons);

            view.playBtnClickSignal.add(onPlayBtnClicked);
            view.flickerBtnClickSignal.add(onFlickerBtnClicked);
        }

        private function onUpdateSignal(outputText:String):void
        {
            view.outputLabel.text = outputText;
        }

        private function onSwitchButtons(state:Boolean):void
        {
            view.playBtn.enabled = state;
            view.flickerBtn.enabled = state;
        }

        private function onPlayBtnClicked():void
        {
            logger.debug(": onPlayBtnClicked");

        }

        private function onEnterFrame(event:Event):void
        {
            var spectrum:ByteArray = new ByteArray();
            SoundMixer.computeSpectrum(spectrum);

            view.mySpectrumGraph.fillRect(view.mySpectrumGraph.rect, 0x00000000);

            for(var i:int=0; i < 256; i++)
            {
                view.mySpectrumGraph.setPixel32(i, 22 + spectrum.readFloat() * 30, 0xffffffff);
            }
        }

        private function onSoundComplete():void
        {
            logger.info("onSoundComplete");

            view.mySpectrumGraph.fillRect(view.mySpectrumGraph.rect, 0x0D1722);

            view.playBtn.label = "PLAY";
            view.playBtn.selected = false;

//            footer.longBeepBtn.enabled = true;
//            footer.shortBeepBtn.enabled = true;
        }


        private function onFlickerBtnClicked():void
        {
            logger.debug(": onFlickerBtnClicked");

            computeFlickerSignal.dispatch();
        }
    }
}
