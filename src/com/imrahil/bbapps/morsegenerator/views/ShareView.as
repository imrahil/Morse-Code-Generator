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

    import flash.desktop.Clipboard;
    import flash.display.Bitmap;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;

    import org.osflash.signals.Signal;

    import qnx.fuse.ui.buttons.IconButton;
    import qnx.fuse.ui.buttons.LabelButton;
    import qnx.fuse.ui.dialog.AlertDialog;
    import qnx.fuse.ui.text.Label;

    public class ShareView extends TitlePage
    {
        public var saveWavBtnClickSignal:Signal = new Signal();
        public var saveMp3BtnClickSignal:Signal = new Signal();

        public var clipboardBtnClickSignal:Signal = new Signal();

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

        private var postLinkDialog:AlertDialog;

        public function ShareView()
        {
            super();

            title = "Share message"
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
//                Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, outputLabel.text);

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
//                navigateToURL(new URLRequest(ApplicationConstants.TWITTER_URL + encodeURI(outputLabel.text)));
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
