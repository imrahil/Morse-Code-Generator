/*
 Copyright (c) 2012 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
package com.imrahil.bbapps.morsegenerator.controller
{
    import com.imrahil.bbapps.morsegenerator.services.IPurchaseService;

    import org.robotlegs.mvcs.SignalCommand;

    public class GetExistingPurchasesCommand extends SignalCommand
    {
        [Inject]
        public var purchaseService:IPurchaseService;

        override public function execute():void
        {
            purchaseService.getExistingPurchases();
        }
    }
}
