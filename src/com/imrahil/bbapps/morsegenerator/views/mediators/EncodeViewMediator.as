/*
 Copyright (c) 2012 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
package com.imrahil.bbapps.morsegenerator.views.mediators
{
    import com.imrahil.bbapps.morsegenerator.signals.ComputeFlickerSignal;
    import com.imrahil.bbapps.morsegenerator.signals.RequestInputOutputValueSignal;
    import com.imrahil.bbapps.morsegenerator.signals.TranslateSignal;
    import com.imrahil.bbapps.morsegenerator.signals.signaltons.MorseCodePlaySignal;
    import com.imrahil.bbapps.morsegenerator.signals.signaltons.ProvideInputOutputValueSignal;
    import com.imrahil.bbapps.morsegenerator.signals.signaltons.SwitchMorseCodePlaySignal;
    import com.imrahil.bbapps.morsegenerator.signals.signaltons.UpdateOutputSignal;
    import com.imrahil.bbapps.morsegenerator.utils.LogUtil;
    import com.imrahil.bbapps.morsegenerator.utils.MorseUtil;
    import com.imrahil.bbapps.morsegenerator.views.EncodeView;

    import flash.events.Event;
    import flash.media.SoundMixer;
    import flash.utils.ByteArray;

    import mx.logging.ILogger;

    import org.robotlegs.mvcs.SignalMediator;

    public class EncodeViewMediator extends SignalMediator
    {
        [Inject]
        public var view:EncodeView;

        [Inject]
        public var requestInputText:RequestInputOutputValueSignal;

        [Inject]
        public var provideInputText:ProvideInputOutputValueSignal;

        [Inject]
        public var translateSignal:TranslateSignal;

        [Inject]
        public var updateOutputSignal:UpdateOutputSignal;

        [Inject]
        public var switchMorseCodePlaySignal:SwitchMorseCodePlaySignal;

        [Inject]
        public var morseCodePlaySignal:MorseCodePlaySignal;

        [Inject]
        public var computeFlickerSignal:ComputeFlickerSignal;

        /** variables **/
        private var logger:ILogger;

        public function EncodeViewMediator()
        {
            super();

            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        override public function onRegister():void
        {
            logger.debug(": onRegister");

            addToSignal(updateOutputSignal, onUpdateSignal);
            addToSignal(switchMorseCodePlaySignal, onSwitchMorseCodePlay);

            addToSignal(provideInputText, onProvideInputTextValue);

            addToSignal(view.inputTextChangeSignal, onInputTextChanged);
            addToSignal(view.playBtnClickSignal, onPlayBtnClicked);
            addToSignal(view.flickerBtnClickSignal, onFlickerBtnClicked);
            addToSignal(view.viewAddedSignal, onViewAdded);
        }

        private function onViewAdded():void
        {
            requestInputText.dispatch();
        }

        private function onProvideInputTextValue(value:String):void
        {
            if (view && view.inputText)
            {
                view.inputText.text = value;

                if (value != "")
                {
                    view.playBtn.enabled = true;
                    view.flickerBtn.enabled = true;
                }
            }
        }

        private function onInputTextChanged(inputText:String):void
        {
            logger.info("onInputTextChanged");

            if (inputText == "" || MorseUtil.isMorse(inputText))
            {
                view.playBtn.enabled = false;
                view.flickerBtn.enabled = false;
            }
            else
            {
                view.playBtn.enabled = true;
                view.flickerBtn.enabled = true;
            }

            translateSignal.dispatch(inputText);
        }

        private function onUpdateSignal(outputText:String):void
        {
            view.outputLabel.text = outputText;
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

            for (var i:int = 0; i < 512; i++)
            {
                view.mySpectrumGraph.setPixel32(i, 44 + spectrum.readFloat() * 40, 0xffffffff);
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

        private function onPlayBtnClicked():void
        {
            logger.debug(": onPlayBtnClicked");

            morseCodePlaySignal.dispatch();
        }

        private function onFlickerBtnClicked():void
        {
            logger.debug(": onFlickerBtnClicked");

            computeFlickerSignal.dispatch();
        }
    }
}
