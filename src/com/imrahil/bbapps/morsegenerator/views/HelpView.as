/*
 Copyright (c) 2012 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
package com.imrahil.bbapps.morsegenerator.views
{
    import com.imrahil.bbapps.morsegenerator.constants.Resources;
    import com.imrahil.bbapps.morsegenerator.utils.TextFormatUtil;

    import flash.display.Graphics;
    import flash.display.Sprite;
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

    public class HelpView extends TitlePage
    {
        public var longBeepClickSignal:Signal = new Signal();
        public var shortBeepClickSignal:Signal = new Signal();

        public var longBeepBtn:LabelButton;
        public var shortBeepBtn:LabelButton;

        public function HelpView()
        {
            super();

            title = "Help";
        }

        override protected function onAdded():void
        {
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
            var g:Graphics = s.graphics;
            g.beginFill(0x0c151c);
            g.drawRect(0, 0, 10, 10);
            g.endFill();

            container.background = s;

            var infoLabel:Label = new Label();
            infoLabel.text = "International Morse Code:";
            infoLabel.format = TextFormatUtil.setFormat(infoLabel.format);

            container.addChild(infoLabel);

            var morseTableImage:Image = new Image();
            morseTableImage.setImage(new Resources.MORSE_TABLE());
            morseTableImage.fixedAspectRatio = true;

            var morseTableData:GridData = new GridData();
            morseTableData.setOptions(SizeOptions.NONE);
            morseTableData.hAlign = Align.BEGIN;
            morseTableData.marginTop = 20;
            morseTableData.marginBottom = 80;
            morseTableImage.layoutData = morseTableData;

            container.addChild(morseTableImage);

            infoLabel = new Label();
            infoLabel.text = "Training Mode:";
            infoLabel.format = TextFormatUtil.setFormat(infoLabel.format);

            container.addChild(infoLabel);


            var trainingBtnContainer:Container = new Container();
            layout = new GridLayout();
            layout.numColumns = 2;
            layout.hSpacing = 40;
            layout.paddingTop = 30;
            layout.paddingBottom = 20;
            trainingBtnContainer.layout = layout;

            var containerData:GridData = new GridData();
            containerData.hAlign = Align.FILL;
            containerData.vAlign = Align.FILL;
            containerData.preferredHeight = 300;
            containerData.setOptions(SizeOptions.RESIZE_HORIZONTAL);
            trainingBtnContainer.layoutData = containerData;

            longBeepBtn = new LabelButton();
            longBeepBtn.label = "Long Beep";
            longBeepBtn.addEventListener(MouseEvent.CLICK, onLongBeepClick);
            longBeepBtn.layoutData = containerData;
            trainingBtnContainer.addChild(longBeepBtn);

            shortBeepBtn = new LabelButton();
            shortBeepBtn.label = "Short Beep";
            shortBeepBtn.addEventListener(MouseEvent.CLICK, onShortBeepClick);
            shortBeepBtn.layoutData = containerData;
            trainingBtnContainer.addChild(shortBeepBtn);

            container.addChild(trainingBtnContainer);

            content = container;
        }

        private function onLongBeepClick(event:MouseEvent):void
        {
            longBeepClickSignal.dispatch();
        }

        private function onShortBeepClick(event:MouseEvent):void
        {
            shortBeepClickSignal.dispatch();
        }
    }
}
