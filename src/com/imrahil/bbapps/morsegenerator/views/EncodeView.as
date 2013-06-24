/*
 Copyright (c) 2013 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
package com.imrahil.bbapps.morsegenerator.views
{
    import com.imrahil.bbapps.morsegenerator.utils.TextFormatUtil;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import org.osflash.signals.Signal;

    import qnx.fuse.ui.buttons.LabelButton;
    import qnx.fuse.ui.core.Container;
    import qnx.fuse.ui.core.SizeOptions;
    import qnx.fuse.ui.display.Image;
    import qnx.fuse.ui.layouts.Align;
    import qnx.fuse.ui.layouts.gridLayout.GridData;
    import qnx.fuse.ui.layouts.gridLayout.GridLayout;
    import qnx.fuse.ui.text.Label;
    import qnx.fuse.ui.text.TextFormat;
    import qnx.fuse.ui.text.TextInput;

    public class EncodeView extends TitlePage
    {
        public var inputTextChangeSignal:Signal = new Signal(String);
        public var playBtnClickSignal:Signal = new Signal();
        public var flickerBtnClickSignal:Signal = new Signal();

        public var viewAddedSignal:Signal = new Signal();

        public var inputText:TextInput;
        public var outputLabel:Label;
        public var mySpectrumGraph:BitmapData;

        public var playBtn:LabelButton;
        public var flickerBtn:LabelButton;

        public function EncodeView()
        {
            super();

            title = "Morse Code Generator";
        }

        override protected function onAdded():void
        {
            super.onAdded();

            var infoLabel:Label;

            var layout:GridLayout = new GridLayout();
            layout.paddingLeft = 30;
            layout.paddingRight = 30;
            layout.paddingTop = 30;
            layout.paddingBottom = 30;
            container.layout = layout;

            infoLabel = new Label();
            infoLabel.text = "Input";
            infoLabel.format = TextFormatUtil.setFormat(infoLabel.format);
            container.addChild(infoLabel);

            inputText = new TextInput();
            inputText.maxChars = 100;
            inputText.spellCheck = false;
            inputText.autoCorrect = false;
            inputText.restrict = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890.,:?\'-/()"@= ';

            var inputTextGridData:GridData = new GridData();
            inputTextGridData.marginTop = 15;
            inputTextGridData.marginBottom = 40;
            inputTextGridData.hAlign = Align.FILL;
            inputTextGridData.vAlign = Align.END;
            inputText.layoutData = inputTextGridData;

            CONFIG::debugMode
            {
                inputText.text = "TEST";
            }

            inputText.addEventListener(Event.CHANGE, onInputTextChange);
            container.addChild(inputText);

            infoLabel = new Label();
            infoLabel.text = "Output";
            infoLabel.format = TextFormatUtil.setFormat(infoLabel.format);
            container.addChild(infoLabel);

            outputLabel = new Label();
            outputLabel.maxLines = 2;
            var outputLayoutData:GridData = new GridData();
            inputTextGridData.marginTop = 15;
            inputTextGridData.marginBottom = 40;
            outputLayoutData.hAlign = Align.FILL;
            outputLayoutData.vAlign = Align.FILL;
            outputLabel.layoutData = outputLayoutData;

            var morseTextFormat:TextFormat = outputLabel.format;
            morseTextFormat.size = 54;
            morseTextFormat.color = 0xFAFAFA;
            morseTextFormat.font = "Slate Pro Light";
            morseTextFormat.bold = true;
            outputLabel.format = morseTextFormat;

            container.addChild(outputLabel);

            var playFlickerContainer:Container = new Container();
            layout = new GridLayout();
            layout.numColumns = 2;
            layout.hSpacing = 40;
            layout.paddingTop = 20;
            layout.paddingBottom = 20;
            playFlickerContainer.layout = layout;

            var btnContainerData:GridData = new GridData();
            btnContainerData.hAlign = Align.FILL;
            btnContainerData.vAlign = Align.FILL;
            btnContainerData.setOptions(SizeOptions.RESIZE_HORIZONTAL);
            playFlickerContainer.layoutData = btnContainerData;

            playBtn = new LabelButton();
            playBtn.label = "PLAY";
            playBtn.enabled = false;
            playBtn.addEventListener(MouseEvent.CLICK, onPlayBtnClick);
            playBtn.layoutData = btnContainerData;
            playFlickerContainer.addChild(playBtn);

            flickerBtn = new LabelButton();
            flickerBtn.label = "FLICKER";
            flickerBtn.enabled = false;
            flickerBtn.addEventListener(MouseEvent.CLICK, onFlickerBtnClick);
            flickerBtn.layoutData = btnContainerData;
            playFlickerContainer.addChild(flickerBtn);

            container.addChild(playFlickerContainer);

            var graphContainer:Container = new Container();
            var graphContainerLayout:GridLayout = new GridLayout();
            graphContainerLayout.paddingLeft = 80;
            graphContainer.layout = graphContainerLayout;

            mySpectrumGraph = new BitmapData(600, 90, true, 0x00000000);
            var bitmap:Bitmap = new Bitmap(mySpectrumGraph);
            var spectrumImage:Image = new Image();
            spectrumImage.setImage(bitmap);
            graphContainer.addChild(spectrumImage);

            container.addChild(graphContainer);

            content = container;

            viewAddedSignal.dispatch();
        }

        private function onInputTextChange(event:Event):void
        {
            inputText.text = inputText.text.toUpperCase();
            inputTextChangeSignal.dispatch(inputText.text);
        }

        private function onPlayBtnClick(event:MouseEvent):void
        {
            playBtnClickSignal.dispatch();
        }

        private function onFlickerBtnClick(event:MouseEvent):void
        {
            flickerBtnClickSignal.dispatch();
        }
    }
}
