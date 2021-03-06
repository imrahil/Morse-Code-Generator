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
    import com.imrahil.bbapps.morsegenerator.signals.signaltons.ProvidePurchaseStatusSignal;

    import org.robotlegs.mvcs.SignalCommand;

    public class ProvidePurchaseStatusCommand extends SignalCommand
    {
        [Inject]
        public var model:IMorseCodeModel;

        [Inject]
        public var providePurchaseStatusSignal:ProvidePurchaseStatusSignal;

        override public function execute():void
        {
            providePurchaseStatusSignal.dispatch(model.purchaseStatus);
        }
    }
}
