/*
 Copyright (c) 2012 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
package com.imrahil.bbapps.morsegenerator.views
{
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.TextFieldAutoSize;

    import org.osflash.signals.Signal;

    import qnx.fuse.ui.buttons.CheckBox;
    import qnx.fuse.ui.buttons.LabelButton;
    import qnx.fuse.ui.core.Container;
    import qnx.fuse.ui.events.SliderEvent;
    import qnx.fuse.ui.skins.SkinStates;
    import qnx.fuse.ui.slider.Slider;
    import qnx.fuse.ui.slider.VolumeSlider;
    import qnx.fuse.ui.text.Label;
    import qnx.fuse.ui.text.TextFormat;
    import qnx.fuse.ui.text.TextInput;
    import qnx.system.AudioManager;
    import qnx.system.AudioOutput;

    public class LeftContainer
    {
        public var speedSlider:Slider;
        public var volumeSlider:VolumeSlider;
        public var translateBtn:LabelButton;

        public var inputTextChangeSignal:Signal = new Signal(String);
        public var translateBtnClickSignal:Signal = new Signal(String);

        public var volumeSliderSignal:Signal = new Signal(Number);
        public var speedSliderSignal:Signal = new Signal(int);

        private var inputText:TextInput;

        public function LeftContainer(format:TextFormat)
        {
            super(format);
        }

        private function create(event:Event):void
        {
            var titleLabel:Label = new Label();
            titleLabel.text = "Input:";
            titleLabel.width = 120;

            inputText = new TextInput();
            inputText.width = 415;
            inputText.maxChars = 100;
            inputText.restrict = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890.,:?\'-/()"@= ';

            CONFIG::debugMode
            {
                inputText.text = "TEST";
            }

            inputText.addEventListener(Event.CHANGE, onInputTextChange);

            var previewContainer:Container = new Container();

            var livePreviewChb:CheckBox = new CheckBox();
            livePreviewChb.width = 140;
            livePreviewChb.label = "Live preview";
//            livePreviewChb.setTextFormatForState(textFormat, SkinStates.SELECTED);
//            livePreviewChb.setTextFormatForState(textFormat, SkinStates.UP);
//            livePreviewChb.setTextFormatForState(textFormat, SkinStates.DOWN);
//            livePreviewChb.setTextFormatForState(textFormat, SkinStates.DOWN_SELECTED);
            livePreviewChb.selected = true;
            livePreviewChb.addEventListener(MouseEvent.CLICK, onPreviewChange);
            previewContainer.addChild(livePreviewChb);

            translateBtn = new LabelButton();
            translateBtn.label = "Translate";
            translateBtn.width = 110;
            translateBtn.enabled = false;
            translateBtn.addEventListener(MouseEvent.CLICK, onTranslateBtnClick);
            previewContainer.addChild(translateBtn);

            var volumeLabel:Label = new Label();
            volumeLabel.text = "Volume:";
            volumeLabel.width = 120;

            volumeSlider = new VolumeSlider();
            volumeSlider.width = 415;
            volumeSlider.minimum = 0;
            volumeSlider.maximum = 100;

            CONFIG::device
            {
                volumeSlider.value = AudioManager.audioManager.getOutputLevel(AudioOutput.SPEAKERS);
            }

            CONFIG::debugMode
            {
                volumeSlider.value = 50;
            }

            volumeSlider.addEventListener(SliderEvent.MOVE, onVolumeSliderMove);

            var speedLabel:Label = new Label();
            speedLabel.text = "Play speed:";
            speedLabel.width = 120;

            speedSlider = new Slider();
            speedSlider.width = 415;
            speedSlider.minimum = 0;
            speedSlider.maximum = 9;
            speedSlider.value = 6;
            speedSlider.addEventListener(SliderEvent.MOVE, onSpeedSliderMove);
        }

        private function onInputTextChange(event:Event):void
        {
            inputTextChangeSignal.dispatch(inputText.text);
        }

        private function onTranslateBtnClick(event:MouseEvent):void
        {
            translateBtnClickSignal.dispatch(inputText.text);
        }

        private function onVolumeSliderMove(event:SliderEvent):void
        {
            volumeSliderSignal.dispatch(event.value);
        }

        private function onSpeedSliderMove(event:SliderEvent):void
        {
            speedSliderSignal.dispatch(Math.round(event.value));
        }

        private function onPreviewChange(event:MouseEvent):void
        {
            translateBtn.enabled = !(event.currentTarget as CheckBox).selected;
        }
    }
}
