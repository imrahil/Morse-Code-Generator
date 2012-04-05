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
    import flash.text.TextFormat;

    import org.osflash.signals.Signal;

    import qnx.system.AudioManager;
    import qnx.system.AudioOutput;
    import qnx.ui.buttons.CheckBox;
    import qnx.ui.buttons.LabelButton;
    import qnx.ui.core.Container;
    import qnx.ui.core.ContainerAlign;
    import qnx.ui.core.ContainerFlow;
    import qnx.ui.core.SizeUnit;
    import qnx.ui.core.Spacer;
    import qnx.ui.events.SliderEvent;
    import qnx.ui.skins.SkinStates;
    import qnx.ui.slider.Slider;
    import qnx.ui.slider.VolumeSlider;
    import qnx.ui.text.Label;
    import qnx.ui.text.TextInput;

    public class LeftContainer extends StyledContainer
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

            this.addEventListener(Event.ADDED_TO_STAGE, create)
        }

        private function create(event:Event):void
        {
            this.removeEventListener(Event.ADDED_TO_STAGE, create);

            this.margins = Vector.<Number>([10, 0, 10, 10]);
            this.size = 50;
            this.sizeUnit = SizeUnit.PERCENT;
            this.align = ContainerAlign.NEAR;

            var titleLabel:Label = new Label();
            titleLabel.text = "Input:";
            titleLabel.width = 120;
            titleLabel.autoSize = TextFieldAutoSize.CENTER;
            titleLabel.format = textFormat;

            inputText = new TextInput();
            inputText.width = 415;
            inputText.maxChars = 100;
            inputText.restrict = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890.,:?\'-/()"@= ';
            inputText.addEventListener(Event.CHANGE, onInputTextChange);

            var previewContainer:Container = new Container();
            previewContainer.size = 30;
            previewContainer.sizeUnit = SizeUnit.PIXELS;
            previewContainer.flow = ContainerFlow.HORIZONTAL;

            var spacer:Spacer;
            spacer = new Spacer(50);
            previewContainer.addChild(spacer);

            var livePreviewChb:CheckBox = new CheckBox();
            livePreviewChb.width = 140;
            livePreviewChb.label = "Live preview";
            livePreviewChb.setTextFormatForState(textFormat, SkinStates.SELECTED);
            livePreviewChb.setTextFormatForState(textFormat, SkinStates.UP);
            livePreviewChb.setTextFormatForState(textFormat, SkinStates.DOWN);
            livePreviewChb.setTextFormatForState(textFormat, SkinStates.DOWN_SELECTED);
            livePreviewChb.selected = true;
            livePreviewChb.addEventListener(MouseEvent.CLICK, onPreviewChange);
            previewContainer.addChild(livePreviewChb);

            spacer = new Spacer(20);
            previewContainer.addChild(spacer);

            translateBtn = new LabelButton();
            translateBtn.label = "Translate";
            translateBtn.width = 110;
            translateBtn.enabled = false;
            translateBtn.addEventListener(MouseEvent.CLICK, onTranslateBtnClick);
            previewContainer.addChild(translateBtn);

            spacer = new Spacer(50);
            previewContainer.addChild(spacer);

            var volumeLabel:Label = new Label();
            volumeLabel.text = "Volume:";
            volumeLabel.width = 120;
            volumeLabel.autoSize = TextFieldAutoSize.CENTER;
            volumeLabel.format = textFormat;

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
            speedLabel.autoSize = TextFieldAutoSize.CENTER;
            speedLabel.format = textFormat;

            speedSlider = new Slider();
            speedSlider.width = 415;
            speedSlider.minimum = 0;
            speedSlider.maximum = 9;
            speedSlider.value = 6;
            speedSlider.addEventListener(SliderEvent.MOVE, onSpeedSliderMove);

            this.addChild(titleLabel);
            this.addChild(inputText);
            this.addChild(new Spacer(20, SizeUnit.PIXELS));
            this.addChild(previewContainer);
            this.addChild(new Spacer(15, SizeUnit.PIXELS));
            this.addChild(volumeLabel);
            this.addChild(volumeSlider);
            this.addChild(new Spacer(35, SizeUnit.PIXELS));
            this.addChild(speedLabel);
            this.addChild(speedSlider);
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
