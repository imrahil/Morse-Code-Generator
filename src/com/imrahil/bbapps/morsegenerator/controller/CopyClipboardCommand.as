/*
 Copyright (c) 2013 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
package com.imrahil.bbapps.morsegenerator.controller
{
    import com.imrahil.bbapps.morsegenerator.model.IMorseCodeModel;
    import com.imrahil.bbapps.morsegenerator.signals.signaltons.CodeCopiedIntoClipboardSignal;

    import flash.desktop.Clipboard;
    import flash.desktop.ClipboardFormats;

    import org.robotlegs.mvcs.SignalCommand;

    public class CopyClipboardCommand extends SignalCommand
    {
        /** INJECTIONS **/
        [Inject]
        public var model:IMorseCodeModel;

        [Inject]
        public var codeCopiedInto:CodeCopiedIntoClipboardSignal;

        override public function execute():void
        {
            Clipboard.generalClipboard.clear();
            Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, model.outputText);

            codeCopiedInto.dispatch();
        }
    }
}
