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

    import flash.display.Bitmap;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.TextFieldAutoSize;

    import org.osflash.signals.Signal;

    import qnx.fuse.ui.buttons.LabelButton;
    import qnx.fuse.ui.core.Container;
    import qnx.fuse.ui.display.Image;
    import qnx.fuse.ui.text.Label;
    import qnx.fuse.ui.text.TextFormat;

    public class FooterView
    {
        public var longBeepClickSignal:Signal = new Signal();
        public var shortBeepClickSignal:Signal = new Signal();

        public var longBeepBtn:LabelButton;
        public var shortBeepBtn:LabelButton;

        public function FooterView(format:TextFormat)
        {
            super(format);
        }

        private function create(event:Event):void
        {
            var morseTableLbl:Label = new Label();
            morseTableLbl.text = "International Morse Code:";

            var morseTable:Bitmap = new Resources.MORSE_TABLE();
            var morseTableImage:Image = new Image();
            morseTableImage.setImage(morseTable);

            var trainLbl:Label = new Label();
            trainLbl.text = "Training Mode";
            trainLbl.width = 140;

            longBeepBtn = new LabelButton();
            longBeepBtn.label = "Long Beep";
            longBeepBtn.width = 120;
            longBeepBtn.height = 120;
            longBeepBtn.addEventListener(MouseEvent.CLICK, onLongBeepClick);

            shortBeepBtn = new LabelButton();
            shortBeepBtn.label = "Short Beep";
            shortBeepBtn.width = 120;
            shortBeepBtn.height = 120;
            shortBeepBtn.addEventListener(MouseEvent.CLICK, onShortBeepClick);
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
