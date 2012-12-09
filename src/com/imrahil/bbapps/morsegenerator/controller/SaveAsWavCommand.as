/*
 Copyright (c) 2012 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
package com.imrahil.bbapps.morsegenerator.controller
{
    import com.imrahil.bbapps.morsegenerator.model.IMorseCodeModel;
    import com.imrahil.bbapps.morsegenerator.services.IMorseCodeService;
    import com.imrahil.bbapps.morsegenerator.utils.MorseUtil;

    import flash.events.Event;
    import flash.events.IOErrorEvent;

    import flash.net.FileReference;
    import flash.utils.ByteArray;

    import org.robotlegs.mvcs.SignalCommand;

    import qnx.fuse.ui.dialog.AlertDialog;

    public class SaveAsWavCommand extends SignalCommand
    {
        [Inject]
        public var model:IMorseCodeModel;

        [Inject]
        public var morseCodeService:IMorseCodeService;

        private var infoAlert:AlertDialog;

        override public function execute():void
        {
            if (MorseUtil.isMorse(model.outputText))
            {
                var wavData:ByteArray = morseCodeService.saveAsWav(model.outputText);

                if (wavData != null)
                {
                    var fileRef:FileReference = new FileReference();
                    fileRef.addEventListener(Event.COMPLETE, onSaveComplete);
                    fileRef.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
                    fileRef.save(wavData, "morseCode.wav");
                }
            }
        }

        private function onSaveComplete(event:Event):void
        {
            CONFIG::device
            {
                infoAlert = new AlertDialog();
                infoAlert.title = "File saved!";
                infoAlert.message = "WAV file has been successfully saved to your Documents folder.";
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
