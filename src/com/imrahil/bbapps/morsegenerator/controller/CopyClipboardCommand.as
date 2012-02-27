package com.imrahil.bbapps.morsegenerator.controller
{
    import com.imrahil.bbapps.morsegenerator.model.IMorseCodeModel;

    import flash.desktop.Clipboard;
    import flash.desktop.ClipboardFormats;

    import org.robotlegs.mvcs.SignalCommand;

    public class CopyClipboardCommand extends SignalCommand
    {
        /** INJECTIONS **/
        [Inject]
        public var model:IMorseCodeModel;

        override public function execute():void
        {
            Clipboard.generalClipboard.clear();
            Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, model.outputText);
        }
    }
}
