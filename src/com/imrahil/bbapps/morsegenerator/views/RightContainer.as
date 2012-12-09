/*
 Copyright (c) 2012 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
package com.imrahil.bbapps.morsegenerator.views
{
    import com.imrahil.bbapps.morsegenerator.constants.ApplicationConstants;
    import com.imrahil.bbapps.morsegenerator.constants.Resources;

    import flash.desktop.Clipboard;
    import flash.desktop.ClipboardFormats;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Graphics;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;
    import flash.text.TextFieldAutoSize;

    import org.osflash.signals.Signal;

    import qnx.fuse.ui.buttons.IconButton;
    import qnx.fuse.ui.buttons.LabelButton;
    import qnx.fuse.ui.core.Container;
    import qnx.fuse.ui.dialog.AlertDialog;
    import qnx.fuse.ui.display.Image;
    import qnx.fuse.ui.text.Label;
    import qnx.fuse.ui.text.TextFormat;

    public class RightContainer
    {
        public var playBtnClickSignal:Signal = new Signal();
        public var flickerBtnClickSignal:Signal = new Signal();

        public var saveWavBtnClickSignal:Signal = new Signal();
        public var saveMp3BtnClickSignal:Signal = new Signal();

        public var clipboardBtnClickSignal:Signal = new Signal();

        public var playBtn:LabelButton;
        public var flickerBtn:LabelButton;

        public var saveWavBtn:LabelButton;
        public var saveMp3Btn:LabelButton;

        public var copyLabel:Label;

        public var clipboardBtn:IconButton;
        public var facebookBtn:IconButton;
        public var twitterBtn:IconButton;

        public var clipboardIcon:Bitmap;
        public var clipboardIconDisabled:Bitmap;
        public var facebookIcon:Bitmap;
        public var facebookIconDisabled:Bitmap;
        public var twitterIcon:Bitmap;
        public var twitterIconDisabled:Bitmap;

        public var mySpectrumGraph:BitmapData;
        public var outputLabel:Label;

        private var postLinkDialog:AlertDialog;

        public function RightContainer(textFormat:TextFormat)
        {
            super(textFormat);
        }

        private function create(event:Event):void
        {
            var titleLabel:Label = new Label();
            titleLabel.text = "Output:";

            var morseTextFormat:TextFormat = new TextFormat();
            morseTextFormat.size = 20;
            morseTextFormat.bold = true;

            outputLabel = new Label();
            outputLabel.maxLines = 0;
            outputLabel.format = morseTextFormat;
            outputLabel.setActualSize(442, 125);

            var g:Graphics = outputLabel.graphics;
            g.lineStyle(1, 0x666666);
            g.moveTo(0, 0);
            g.lineTo(440, 0);
            g.lineTo(440, 125);
            g.lineTo(0, 125);
            g.lineTo(0, 0);

            playBtn = new LabelButton();
            playBtn.label = "PLAY";
            playBtn.enabled = false;
            playBtn.width = 100;
            playBtn.addEventListener(MouseEvent.CLICK, onPlayBtnClick);

            flickerBtn = new LabelButton();
            flickerBtn.label = "FLICKER";
            flickerBtn.enabled = false;
            flickerBtn.width = 100;
            flickerBtn.addEventListener(MouseEvent.CLICK, onFlickerBtnClick);


            copyLabel = new Label();
            copyLabel.text = "";
            copyLabel.width = 55;

            clipboardIconDisabled = new Resources.CLIPBOARD_ICON_DISABLED();
            clipboardBtn = new IconButton();
            clipboardBtn.enabled = false;
            clipboardBtn.width = 50;
            clipboardBtn.setIcon(clipboardIconDisabled);
            clipboardBtn.addEventListener(MouseEvent.CLICK, onClipboardBtnClick);

            facebookIconDisabled = new Resources.FACEBOOK_ICON_DISABLED();
            facebookBtn = new IconButton();
            facebookBtn.enabled = false;
            facebookBtn.width = 50;
            facebookBtn.setIcon(facebookIconDisabled);
            facebookBtn.addEventListener(MouseEvent.CLICK, onFacebookBtnClick);

            twitterIconDisabled = new Resources.TWITTER_ICON_DISABLED();
            twitterBtn = new IconButton();
            twitterBtn.enabled = false;
            twitterBtn.width = 50;
            twitterBtn.setIcon(twitterIconDisabled);
            twitterBtn.addEventListener(MouseEvent.CLICK, onTwitterBtnClick);

            var graphContainer:Container = new Container();

            mySpectrumGraph = new BitmapData(300, 45, true, 0x00000000);
            var bitmap:Bitmap = new Bitmap(mySpectrumGraph);
            var spectrumImage:Image = new Image();
            spectrumImage.setImage(bitmap);
            graphContainer.addChild(spectrumImage);

            saveWavBtn = new LabelButton();
            saveWavBtn.label = "WAV";
            saveWavBtn.enabled = false;
            saveWavBtn.width = 65;
            saveWavBtn.addEventListener(MouseEvent.CLICK, onSaveWavBtnClick);
            graphContainer.addChild(saveWavBtn);

            saveMp3Btn = new LabelButton();
            saveMp3Btn.label = "MP3";
            saveMp3Btn.enabled = false;
            saveMp3Btn.width = 65;
            saveMp3Btn.addEventListener(MouseEvent.CLICK, onSaveMp3BtnClick);
            graphContainer.addChild(saveMp3Btn);
        }

        private function onPlayBtnClick(event:MouseEvent):void
        {
            playBtnClickSignal.dispatch();
        }

        private function onFlickerBtnClick(event:MouseEvent):void
        {
            flickerBtnClickSignal.dispatch();
        }

        private function onClipboardBtnClick(event:MouseEvent):void
        {
            clipboardBtnClickSignal.dispatch();
        }

        private function onFacebookBtnClick(event:MouseEvent):void
        {
            postLinkDialog = new AlertDialog();
            postLinkDialog.title = "Post message on your Facebook wall!";
            postLinkDialog.message = "Your message is in your clipboard. Click OK button to open Facebook webpage and paste it there.";
            postLinkDialog.addButton("OK");
            postLinkDialog.addButton("CANCEL");
            postLinkDialog.addEventListener(Event.SELECT, facebookAlertButtonClickHandler);
            postLinkDialog.show();
        }

        private function facebookAlertButtonClickHandler(event:Event):void
        {
            if (event.target.selectedIndex == 0)
            {
                Clipboard.generalClipboard.clear();
                Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, outputLabel.text);

                navigateToURL(new URLRequest(ApplicationConstants.FACEBOOK_URL));
            }

            postLinkDialog.cancel();
        }

        private function onTwitterBtnClick(event:MouseEvent):void
        {
            postLinkDialog = new AlertDialog();
            postLinkDialog.title = "Post your message on Twitter!";
            postLinkDialog.message = "Click OK button to open Twitter webpage and post your message on your Twitter stream.";
            postLinkDialog.addButton("OK");
            postLinkDialog.addButton("CANCEL");
            postLinkDialog.addEventListener(Event.SELECT, twitterAlertButtonClickHandler);
            postLinkDialog.show();
        }

        private function twitterAlertButtonClickHandler(event:Event):void
        {
            if (event.target.selectedIndex == 0)
            {
                navigateToURL(new URLRequest(ApplicationConstants.TWITTER_URL + encodeURI(outputLabel.text)));
            }

            postLinkDialog.cancel();
        }

        private function onSaveWavBtnClick(event:MouseEvent):void
        {
            saveWavBtnClickSignal.dispatch();
        }

        private function onSaveMp3BtnClick(event:MouseEvent):void
        {
            saveMp3BtnClickSignal.dispatch();
        }
    }
}
