/*
 Copyright (c) 2012 Imrahil Corporation, All Rights Reserved
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
    import flash.display.Graphics;
    import flash.display.Sprite;
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
    import qnx.fuse.ui.listClasses.ScrollDirection;
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
            var g:Graphics;
            var infoLabel:Label;

            super.onAdded();

            var container:Container = new Container();
            container.scrollDirection = ScrollDirection.VERTICAL;

            var layout:GridLayout = new GridLayout();
            layout.paddingLeft = 30;
            layout.paddingRight = 30;
            layout.paddingTop = 30;
            layout.paddingBottom = 30;
            container.layout = layout;

            var s:Sprite = new Sprite();
            g = s.graphics;
            g.beginFill(0x0c151c);
            g.drawRect(0, 0, 10, 10);
            g.endFill();

            container.background = s;

            infoLabel = new Label();
            infoLabel.text = "Input";
            infoLabel.format = TextFormatUtil.setFormat(infoLabel.format);
            container.addChild(infoLabel);

            inputText = new TextInput();
            inputText.width = 415;
            inputText.maxChars = 100;
            inputText.spellCheck = false;
            inputText.autoCorrect = false;
            inputText.restrict = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890.,:?\'-/()"@= ';

            var sliderLayoutData:GridData = new GridData();
            sliderLayoutData.marginTop = 15;
            sliderLayoutData.marginBottom = 40;
            sliderLayoutData.hAlign = Align.FILL;
            sliderLayoutData.vAlign = Align.END;
            inputText.layoutData = sliderLayoutData;

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

            var outputContainer:Container = new Container();
            layout = new GridLayout();
            layout.paddingLeft = 10;
            layout.paddingRight = 10;
            layout.paddingTop = 10;
            layout.paddingBottom = 10;
            outputContainer.layout = layout;

            var containerData:GridData = new GridData();
            containerData.marginTop = 15;
            containerData.marginBottom = 40;
            containerData.hAlign = Align.FILL;
            containerData.vAlign = Align.BEGIN;
            containerData.preferredHeight = 150;
            containerData.setOptions(SizeOptions.NONE);
            outputContainer.layoutData = containerData;

            outputLabel = new Label();
            outputLabel.maxLines = 0;
            var outputLayoutData:GridData = new GridData();
            outputLayoutData.hAlign = Align.FILL;
            outputLayoutData.vAlign = Align.FILL;
            outputLayoutData.setOptions(SizeOptions.RESIZE_BOTH);
            outputLabel.layoutData = outputLayoutData;

            var morseTextFormat:TextFormat = outputLabel.format;
            morseTextFormat.size = 54;
            morseTextFormat.color = 0xFAFAFA;
            morseTextFormat.font = "Slate Pro Light";
            morseTextFormat.bold = true;
            outputLabel.format = morseTextFormat;

            s = new Sprite();
            g = s.graphics;
            g.lineStyle(1, 0x666666);
            g.moveTo(0, 0);
            g.drawRect(0, 0, 500, 500);
            outputContainer.background = s;

            outputContainer.addChild(outputLabel);

            container.addChild(outputContainer);

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
