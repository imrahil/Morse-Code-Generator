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

    import flash.events.Event;
    import flash.events.MouseEvent;

    import qnx.fuse.ui.buttons.IconButton;
    import qnx.fuse.ui.buttons.LabelButton;
    import qnx.fuse.ui.text.Label;
    import qnx.fuse.ui.text.TextFormat;

    public class RightContainer
    {



        public function RightContainer(textFormat:TextFormat)
        {
            super(textFormat);
        }

        private function create(event:Event):void
        {

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


    }
}
