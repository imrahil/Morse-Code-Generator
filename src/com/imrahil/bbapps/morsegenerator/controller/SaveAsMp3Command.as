/*
 Copyright (c) 2012 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
package com.imrahil.bbapps.morsegenerator.controller
{
    import cmodule.shine.CLibInit;

    import com.imrahil.bbapps.morsegenerator.model.IMorseCodeModel;
    import com.imrahil.bbapps.morsegenerator.services.IMorseCodeService;
    import com.imrahil.bbapps.morsegenerator.signals.signaltons.Mp3EncoderStatusSignal;
    import com.imrahil.bbapps.morsegenerator.utils.MorseUtil;

    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.TimerEvent;
    import flash.net.FileReference;
    import flash.utils.ByteArray;
    import flash.utils.Timer;

    import org.robotlegs.mvcs.SignalCommand;

    import qnx.fuse.ui.dialog.AlertDialog;

    public class SaveAsMp3Command extends SignalCommand
    {
        [Inject]
        public var model:IMorseCodeModel;

        [Inject]
        public var morseCodeService:IMorseCodeService;

        [Inject]
        public var mp3EncoderStatusSignal:Mp3EncoderStatusSignal;

        private var infoAlert:AlertDialog;

        private var mp3Data:ByteArray;
        private var cshineObj:Object;
        private var timer:Timer;

        override public function execute():void
        {
            if (MorseUtil.isMorse(model.outputText))
            {
                var wavData:ByteArray = morseCodeService.saveAsWav(model.outputText);

                if (wavData != null)
                {
                    mp3Data = new ByteArray();

                    timer = new Timer(1000 / 30);
                    timer.addEventListener(TimerEvent.TIMER, update);

                    var loader:CLibInit = new CLibInit;
                    cshineObj = loader.init();
                    cshineObj.convert(this, wavData, mp3Data);

                    if (timer) timer.start();
                }
            }
        }

        private function update(event:TimerEvent):void
        {
            var percent:int = cshineObj.update();
            mp3EncoderStatusSignal.dispatch(percent);

            if (percent == 100)
            {
                timer.stop();
                timer.removeEventListener(TimerEvent.TIMER, update);
                timer = null;

                var fileRef:FileReference = new FileReference();
                fileRef.addEventListener(Event.COMPLETE, onSaveComplete);
                fileRef.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
                fileRef.save(mp3Data, "morseCode.mp3");
            }
        }

        private function onSaveComplete(event:Event):void
        {
            CONFIG::device
            {
                infoAlert = new AlertDialog();
                infoAlert.title = "File saved!";
                infoAlert.message = "MP3 file has been successfully saved to your Documents folder.";
                infoAlert.addButton("OK");
                infoAlert.show();
            }
        }

        private function onIOError(event:IOErrorEvent):void
        {
            CONFIG::device
            {
                infoAlert = new AlertDialog();
                infoAlert.title = "Error!";
                infoAlert.message = "Uppss... Something went wrong! If it happens again contact me immediately.";
                infoAlert.addButton("OK");
                infoAlert.show();
            }
        }
    }
}
