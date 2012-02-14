package com.imrahil.bbapps.morsegenerator.views
{
    import flash.events.MouseEvent;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;

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
        public var inputText:TextInput;
        public var translateBtn:LabelButton;
        public var volumeSlider:VolumeSlider;
        public var speedSlider:Slider;

        public function LeftContainer(format:TextFormat)
        {
            super(format);

            create();
        }

        private function create():void
        {
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
            livePreviewChb.selected = true;
            livePreviewChb.addEventListener(MouseEvent.CLICK, onPreviewChange);
            previewContainer.addChild(livePreviewChb);

            spacer = new Spacer(20);
            previewContainer.addChild(spacer);

            translateBtn = new LabelButton();
            translateBtn.label = "Translate";
            translateBtn.width = 110;
            translateBtn.enabled = false;
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
            volumeSlider.value = 100;
            volumeSlider.addEventListener(SliderEvent.MOVE, volumeSlider_moveHandler);

            var speedLabel:Label = new Label();
            speedLabel.text = "Play speed:";
            speedLabel.width = 120;
            speedLabel.autoSize = TextFieldAutoSize.CENTER;
            speedLabel.format = textFormat;

            speedSlider = new Slider();
            speedSlider.width = 415;
            speedSlider.minimum = 0;
            speedSlider.maximum = 8;
            speedSlider.value = 4;

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

        public function get inputValue():String
        {
            return inputText.text;
        }

        public function setVolume(value:Number):void
        {
            volumeSlider.value = value;
        }

        private function onPreviewChange(event:MouseEvent):void
        {
            translateBtn.enabled = !(event.currentTarget as CheckBox).selected;
        }

        private function volumeSlider_moveHandler(event:SliderEvent):void
        {
            AudioManager.audioManager.setOutputLevel(event.value, AudioOutput.SPEAKERS);
        }
    }
}
