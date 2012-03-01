package com.imrahil.bbapps.morsegenerator.views.mediators
{
    import com.imrahil.bbapps.morsegenerator.constants.Resources;
    import com.imrahil.bbapps.morsegenerator.services.IMorseCodeService;
    import com.imrahil.bbapps.morsegenerator.signals.ComputeFlickerSignal;
    import com.imrahil.bbapps.morsegenerator.signals.CopyClipboardSignal;
    import com.imrahil.bbapps.morsegenerator.signals.signaltons.CodeCopiedIntoClipboardSignal;
    import com.imrahil.bbapps.morsegenerator.signals.signaltons.MorseCodePlaySignal;
    import com.imrahil.bbapps.morsegenerator.signals.signaltons.SwitchRightSideButtonsSignal;
    import com.imrahil.bbapps.morsegenerator.signals.signaltons.SwitchMorseCodePlaySignal;
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
        public var morseCodePlaySignal:MorseCodePlaySignal;

        [Inject]
        public var switchRightSideButtonsSignal:SwitchRightSideButtonsSignal;

        [Inject]
        public var switchMorseCodePlaySignal:SwitchMorseCodePlaySignal;

        [Inject]
        public var copyClipboardSignal:CopyClipboardSignal;

        [Inject]
        public var codeCopiedInto:CodeCopiedIntoClipboardSignal;

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
            switchMorseCodePlaySignal.add(onSwitchMorseCodePlay);
            codeCopiedInto.add(onCodeCopied);

            view.playBtnClickSignal.add(onPlayBtnClicked);
            view.flickerBtnClickSignal.add(onFlickerBtnClicked);
            view.clipboardBtnClickSignal.add(onClipboardBtnClicked);
        }

        private function onUpdateSignal(outputText:String):void
        {
            view.outputLabel.text = outputText;

            view.copyLabel.text = "";
        }

        private function onCodeCopied():void
        {
            view.copyLabel.text = "OK";
        }

        private function onSwitchButtons(state:Boolean):void
        {
            view.playBtn.enabled = state;
            view.flickerBtn.enabled = state;

            view.clipboardBtn.enabled = state;
            view.facebookBtn.enabled = state;

            if (state)
            {
                if (!view.clipboardIcon)
                {
                    view.clipboardIcon = new Resources.CLIPBOARD_ICON();
                }
                view.clipboardBtn.setIcon(view.clipboardIcon);

                if (!view.facebookIcon)
                {
                    view.facebookIcon = new Resources.FACEBOOK_ICON();
                }
                view.facebookBtn.setIcon(view.facebookIcon);
            }
            else
            {
                view.clipboardBtn.setIcon(view.clipboardIconDisabled);
                view.facebookBtn.setIcon(view.facebookIconDisabled);
            }
        }

        private function onPlayBtnClicked():void
        {
            logger.debug(": onPlayBtnClicked");

            morseCodePlaySignal.dispatch();
        }

        private function onSwitchMorseCodePlay(state:Boolean):void
        {
            if (state)
            {
                view.playBtn.label = "STOP";

                this.addViewListener(Event.ENTER_FRAME, onEnterFrame);
            }
            else
            {
                view.playBtn.label = "PLAY";

                onSoundComplete();
            }
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

            this.removeViewListener(Event.ENTER_FRAME, onEnterFrame);

            view.mySpectrumGraph.fillRect(view.mySpectrumGraph.rect, 0x0D1722);

            view.playBtn.label = "PLAY";
            view.playBtn.selected = false;
        }

        private function onFlickerBtnClicked():void
        {
            logger.debug(": onFlickerBtnClicked");

            computeFlickerSignal.dispatch();
        }

        private function onClipboardBtnClicked():void
        {
            logger.debug(": onClipboardBtnClicked");

            copyClipboardSignal.dispatch();
        }
    }
}
