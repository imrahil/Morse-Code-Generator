/*
 Copyright (c) 2012 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
package com.imrahil.bbapps.morsegenerator.views.mediators
{
    import com.imrahil.bbapps.morsegenerator.constants.ApplicationConstants;
    import com.imrahil.bbapps.morsegenerator.signals.CopyClipboardSignal;
    import com.imrahil.bbapps.morsegenerator.signals.RequestInputOutputValueSignal;
    import com.imrahil.bbapps.morsegenerator.signals.SaveAsMp3Signal;
    import com.imrahil.bbapps.morsegenerator.signals.SaveAsWavSignal;
    import com.imrahil.bbapps.morsegenerator.signals.signaltons.CodeCopiedIntoClipboardSignal;
    import com.imrahil.bbapps.morsegenerator.signals.signaltons.Mp3EncoderStatusSignal;
    import com.imrahil.bbapps.morsegenerator.signals.signaltons.UpdateOutputSignal;
    import com.imrahil.bbapps.morsegenerator.utils.LogUtil;
    import com.imrahil.bbapps.morsegenerator.views.ShareView;

    import flash.desktop.Clipboard;
    import flash.desktop.ClipboardFormats;
    import flash.events.TimerEvent;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;
    import flash.utils.ByteArray;
    import flash.utils.Timer;

    import mx.logging.ILogger;

    import org.robotlegs.mvcs.SignalMediator;

    import qnx.invoke.InvokeAction;
    import qnx.invoke.InvokeManager;

    import qnx.invoke.InvokeRequest;

    public class ShareViewMediator extends SignalMediator
    {
        [Inject]
        public var view:ShareView;

        [Inject]
        public var requestInputOutputValue:RequestInputOutputValueSignal;

        [Inject]
        public var updateOutputSignal:UpdateOutputSignal;

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

        private var currentOutputValue:String;

        public function ShareViewMediator()
        {
            super();

            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        override public function onRegister():void
        {
            logger.debug(": onRegister");

            addToSignal(updateOutputSignal, onOutputValueSignal);
            addToSignal(codeCopiedInto, onCodeCopied);
            addToSignal(mp3EncoderStatusSignal, onEncoderStatus);

            addToSignal(view.clipboardBtnClickSignal, onClipboardBtnClicked);
            addToSignal(view.bbmBtnClickSignal, onBBMBtnClicked);
            addToSignal(view.facebookBtnClickSignal, onFacebookBtnClicked);
            addToSignal(view.twitterBtnClickSignal, onTwitterBtnClicked);

            addToSignal(view.saveWavBtnClickSignal, onSaveWavBtnClicked);
            addToSignal(view.saveMp3BtnClickSignal, onSaveMp3BtnClicked);

            addToSignal(view.viewAddedSignal, onViewAdded);
        }

        private function onViewAdded():void
        {
            requestInputOutputValue.dispatch();
        }

        private function onOutputValueSignal(outputText:String):void
        {
            currentOutputValue = outputText;

            if (outputText != "")
            {
               view.addComponents(true);
            }
            else
            {
                view.addComponents(false);
            }
        }

        private function onCodeCopied():void
        {
            view.copyLabelClipboard.text = "OK";

            var cleanLabelTimer:Timer = new Timer(2000, 1);
            cleanLabelTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onCleanLabelTimerComplete);
            cleanLabelTimer.start();
        }

        private function onCleanLabelTimerComplete(event:TimerEvent):void
        {
            view.copyLabelClipboard.text = "";
        }

        private function onEncoderStatus(percent:uint):void
        {
            if (percent < 100)
            {
                view.encoderLabel.text = percent + "%";
            }
            else
            {
                view.encoderLabel.text = "";
            }
        }

        private function onClipboardBtnClicked():void
        {
            logger.debug(": onClipboardBtnClicked");

            copyClipboardSignal.dispatch();
        }

        private function onBBMBtnClicked():void
        {
            logger.debug(": onBBMBtnClicked");

            var byteData:ByteArray = new ByteArray();
            byteData.writeUTFBytes(currentOutputValue);

            var request:InvokeRequest = new InvokeRequest();
            request.mimeType = "text/plain";
            request.target = "sys.bbm.sharehandler";
            request.action = InvokeAction.SHARE;
            request.data = byteData;

            InvokeManager.invokeManager.invoke(request);
        }

        private function onFacebookBtnClicked():void
        {
            logger.debug(": onFacebookBtnClicked");

            Clipboard.generalClipboard.clear();
            Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, currentOutputValue);

            navigateToURL(new URLRequest(ApplicationConstants.FACEBOOK_URL));
        }

        private function onTwitterBtnClicked():void
        {
            logger.debug(": onTwitterBtnClicked");

            navigateToURL(new URLRequest(ApplicationConstants.TWITTER_URL + encodeURI(currentOutputValue) + ApplicationConstants.TWITTER_URL_COPY));
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
