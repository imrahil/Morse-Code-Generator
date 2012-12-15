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
    import flash.events.Event;
    import flash.events.MouseEvent;

    import org.osflash.signals.Signal;

    import qnx.fuse.ui.buttons.IconButton;
    import qnx.fuse.ui.buttons.LabelButton;
    import qnx.fuse.ui.core.Container;
    import qnx.fuse.ui.core.SizeOptions;
    import qnx.fuse.ui.dialog.AlertDialog;
    import qnx.fuse.ui.layouts.Align;
    import qnx.fuse.ui.layouts.gridLayout.GridData;
    import qnx.fuse.ui.layouts.gridLayout.GridLayout;
    import qnx.fuse.ui.listClasses.ScrollDirection;
    import qnx.fuse.ui.text.Label;

    public class ShareView extends TitlePage
    {
        public var clipboardBtnClickSignal:Signal = new Signal();
        public var facebookBtnClickSignal:Signal = new Signal();
        public var twitterBtnClickSignal:Signal = new Signal();

        public var saveWavBtnClickSignal:Signal = new Signal();
        public var saveMp3BtnClickSignal:Signal = new Signal();

        public var viewAddedSignal:Signal = new Signal();

        public var saveWavBtn:LabelButton;
        public var saveMp3Btn:LabelButton;

        public var copyLabelClipboard:Label;
        public var encoderLabel:Label;

        private var postLinkDialog:AlertDialog;

        public function ShareView()
        {
            super();

            title = "Share message"
        }

        override protected function onAdded():void
        {
            super.onAdded();

            viewAddedSignal.dispatch();
        }

        public function addComponents(enabled:Boolean):void
        {
            var infoLabel:Label;
            var twoColumnContainer:Container;
            var iconBtn:IconButton;
            var labelBtn:LabelButton;

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

            // COPY LABEL + INFO LABEL
            twoColumnContainer = new Container()
            twoColumnContainer.layout = prepareTwoLabelColumnLayout();

            infoLabel = new Label();
            infoLabel.text = "Copy to clipboard";
            infoLabel.format = TextFormatUtil.setFormat(infoLabel.format);
            twoColumnContainer.addChild(infoLabel);

            copyLabelClipboard = new Label();
            copyLabelClipboard.format = TextFormatUtil.setFormat(infoLabel.format);
            twoColumnContainer.addChild(copyLabelClipboard);

            container.addChild(twoColumnContainer);

            // CLIPBOARD BUTTON
            twoColumnContainer = new Container();
            twoColumnContainer.layout = prepareColumnLayout(1);

            iconBtn = new IconButton();
            if (enabled)
            {
                iconBtn.setIcon(new Resources.CLIPBOARD_ICON());
            }
            else
            {
                iconBtn.setIcon(new Resources.CLIPBOARD_ICON_DISABLED());
                iconBtn.enabled = false;
            }

            iconBtn.addEventListener(MouseEvent.CLICK, onClipboardBtnClick);
            iconBtn.layoutData = prepareButtonGridData();
            twoColumnContainer.addChild(iconBtn);

            container.addChild(twoColumnContainer);

            // FACEBOOK/TWITTER LABEL
            infoLabel = new Label();
            infoLabel.text = "Share to Facebook or Twitter";
            infoLabel.format = TextFormatUtil.setFormat(infoLabel.format);
            container.addChild(infoLabel);

            // FACEBOOK/TWITTER BUTTONS
            twoColumnContainer = new Container();
            twoColumnContainer.layout = prepareColumnLayout();

            iconBtn = new IconButton();
            if (enabled)
            {
                iconBtn.setIcon(new Resources.FACEBOOK_ICON());
            }
            else
            {
                iconBtn.setIcon(new Resources.FACEBOOK_ICON_DISABLED());
                iconBtn.enabled = false;
            }

            iconBtn.addEventListener(MouseEvent.CLICK, onFacebookBtnClick);
            iconBtn.layoutData = prepareButtonGridData();
            twoColumnContainer.addChild(iconBtn);

            iconBtn = new IconButton();
            if (enabled)
            {
                iconBtn.setIcon(new Resources.TWITTER_ICON());
            }
            else
            {
                iconBtn.setIcon(new Resources.TWITTER_ICON_DISABLED());
                iconBtn.enabled = false;
            }

            iconBtn.addEventListener(MouseEvent.CLICK, onTwitterBtnClick);
            iconBtn.layoutData = prepareButtonGridData();
            twoColumnContainer.addChild(iconBtn);

            container.addChild(twoColumnContainer);

            twoColumnContainer = new Container()
            twoColumnContainer.layout = prepareTwoLabelColumnLayout();

            infoLabel = new Label();
            infoLabel.text = "Save as...";
            infoLabel.format = TextFormatUtil.setFormat(infoLabel.format);
            twoColumnContainer.addChild(infoLabel);

            encoderLabel = new Label();
            encoderLabel.format = TextFormatUtil.setFormat(infoLabel.format);
            twoColumnContainer.addChild(encoderLabel);

            container.addChild(twoColumnContainer);

            // WAV/MP3 BUTTONS
            twoColumnContainer = new Container();
            twoColumnContainer.layout = prepareColumnLayout();

            // WAV BUTTON
            labelBtn = new LabelButton();
            labelBtn.label = "WAV";

            if (!enabled)
            {
                labelBtn.enabled = false;
            }

            labelBtn.addEventListener(MouseEvent.CLICK, onSaveWavBtnClick);
            labelBtn.layoutData = prepareButtonGridData();
            twoColumnContainer.addChild(labelBtn);

            // MP3 BUTTON
            labelBtn = new LabelButton();
            labelBtn.label = "MP3";

            if (!enabled)
            {
                labelBtn.enabled = false;
            }

            labelBtn.addEventListener(MouseEvent.CLICK, onSaveMp3BtnClick);
            labelBtn.layoutData = prepareButtonGridData();
            twoColumnContainer.addChild(labelBtn);

            container.addChild(twoColumnContainer);

            content = container;
        }

        private static function prepareButtonGridData():GridData
        {
            var buttonLayoutData:GridData = new GridData();
            buttonLayoutData.preferredHeight = 150;
//            buttonLayoutData.hAlign = Align.FILL;
//            buttonLayoutData.vAlign = Align.FILL;
//            buttonLayoutData.setOptions(SizeOptions.RESIZE_HORIZONTAL);

            return buttonLayoutData;
        }

        private static function prepareTwoLabelColumnLayout():GridLayout
        {
            var twoColumnWithLabelsLayout:GridLayout = new GridLayout(2);
            twoColumnWithLabelsLayout.hSpacing = 40;

            return twoColumnWithLabelsLayout;
        }

        private static function prepareColumnLayout(numColumns:int = 2):GridLayout
        {
            var twoColumnLayout:GridLayout = new GridLayout();
            twoColumnLayout.numColumns = numColumns;
            twoColumnLayout.hAlign = Align.FILL;
            twoColumnLayout.vAlign = Align.FILL;
            twoColumnLayout.hSpacing = 40;
            twoColumnLayout.paddingTop = 30;
            twoColumnLayout.paddingBottom = 40;
            twoColumnLayout.setOptions(SizeOptions.RESIZE_HORIZONTAL)

            return twoColumnLayout;
        }

        private function onClipboardBtnClick(event:MouseEvent):void
        {
            clipboardBtnClickSignal.dispatch();
        }

        private function onFacebookBtnClick(event:MouseEvent):void
        {
            postLinkDialog = new AlertDialog();
            postLinkDialog.title = "Post message on your Facebook wall!";
            postLinkDialog.message = "Your encoded message is in your clipboard. Click OK button to open Facebook webpage and paste it there.";
            postLinkDialog.addButton("OK");
            postLinkDialog.addButton("CANCEL");
            postLinkDialog.addEventListener(Event.SELECT, facebookAlertButtonClickHandler);
            postLinkDialog.show();
        }

        private function facebookAlertButtonClickHandler(event:Event):void
        {
            if (event.target.selectedIndex == 0)
            {
                facebookBtnClickSignal.dispatch();
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
                twitterBtnClickSignal.dispatch();
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
