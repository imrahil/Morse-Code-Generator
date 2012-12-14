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
    import com.imrahil.bbapps.morsegenerator.signals.signaltons.ProvideInputOutputValueSignal;
    import com.imrahil.bbapps.morsegenerator.signals.signaltons.UpdateOutputSignal;

    import org.robotlegs.mvcs.SignalCommand;

    public class ProvideInputOutputValueCommand extends SignalCommand
    {
        [Inject]
        public var model:IMorseCodeModel;

        [Inject]
        public var provideInputText:ProvideInputOutputValueSignal;

        [Inject]
        public var updateOutputSignal:UpdateOutputSignal;

        override public function execute():void
        {
            provideInputText.dispatch(model.inputText);
            updateOutputSignal.dispatch(model.outputText);
        }
    }
}
