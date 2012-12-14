/*
 Copyright (c) 2012 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
package com.imrahil.bbapps.morsegenerator.views.mediators
{
    import com.imrahil.bbapps.morsegenerator.constants.Resources;
    import com.imrahil.bbapps.morsegenerator.signals.CopyClipboardSignal;
    import com.imrahil.bbapps.morsegenerator.signals.SaveAsMp3Signal;
    import com.imrahil.bbapps.morsegenerator.signals.SaveAsWavSignal;
    import com.imrahil.bbapps.morsegenerator.signals.signaltons.CodeCopiedIntoClipboardSignal;
    import com.imrahil.bbapps.morsegenerator.signals.signaltons.Mp3EncoderStatusSignal;
    import com.imrahil.bbapps.morsegenerator.utils.LogUtil;
    import com.imrahil.bbapps.morsegenerator.views.ShareView;

    import mx.logging.ILogger;

    import org.robotlegs.mvcs.SignalMediator;

    public class ShareViewMediator extends SignalMediator
    {
        [Inject]
        public var view:ShareView;

        [Inject]
        public var copyClipboardSignal:CopyClipboardSignal;

        [Inject]
        public var codeCopiedInto:CodeCopiedIntoClipboardSignal;

        [Inject]
        public var saveAsWavSignal:SaveAsWavSignal;

        [Inject]
        public var saveAsMp3Signal:SaveAsMp3Signal;

        [Inject]
        public var mp3EncoderStatusSignal:Mp3EncoderStatusSignal;

        /** variables **/
        private var logger:ILogger;

        public function ShareViewMediator()
        {
            super();

            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        override public function onRegister():void
        {
            logger.debug(": onRegister");

            addToSignal(codeCopiedInto, onCodeCopied);
            addToSignal(mp3EncoderStatusSignal, onEncoderStatus);

            addToSignal(view.clipboardBtnClickSignal, onClipboardBtnClicked);

            addToSignal(view.saveWavBtnClickSignal, onSaveWavBtnClicked);
            addToSignal(view.saveMp3BtnClickSignal, onSaveMp3BtnClicked);
        }

        private function onCodeCopied():void
        {
            view.copyLabel.text = "OK";
        }

        private function onEncoderStatus(percent:uint):void
        {
            if (percent < 100)
            {
                view.copyLabel.text = percent + "%";
            }
            else
            {
                view.copyLabel.text = "";
            }
        }

        private function onSwitchButtons(state:Boolean):void
        {
            view.saveWavBtn.enabled = state;
            view.saveMp3Btn.enabled = state;

            view.clipboardBtn.enabled = state;
            view.facebookBtn.enabled = state;
            view.twitterBtn.enabled = state;

            if (state)
            {
                if (!view.clipboardIcon)
                {
                    view.clipboardIcon = new Resources.CLIPBOARD_ICON();
                }
                view.clipboardBtn.setIcon(view.clipboardIcon);

                if (!view.facebookIcon)
                {
                    view.facebookIcon = new Resources.FACEBOOK_ICON();
                }
                view.facebookBtn.setIcon(view.facebookIcon);

                if (!view.twitterIcon)
                {
                    view.twitterIcon = new Resources.TWITTER_ICON();
                }
                view.twitterBtn.setIcon(view.twitterIcon);
            }
            else
            {
                view.clipboardBtn.setIcon(view.clipboardIconDisabled);
                view.facebookBtn.setIcon(view.facebookIconDisabled);
                view.twitterBtn.setIcon(view.twitterIconDisabled);
            }
        }

        private function onClipboardBtnClicked():void
        {
            logger.debug(": onClipboardBtnClicked");

            copyClipboardSignal.dispatch();
        }

        private function onSaveWavBtnClicked():void
        {
            logger.debug(": onSaveWavBtnClicked");

            saveAsWavSignal.dispatch();
        }

        private function onSaveMp3BtnClicked():void
        {
            logger.debug(": onSaveMp3BtnClicked");

            saveAsMp3Signal.dispatch();
        }
    }
}
