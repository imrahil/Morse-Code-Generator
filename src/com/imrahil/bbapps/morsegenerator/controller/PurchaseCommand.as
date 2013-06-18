/*
 Copyright (c) 2013 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
package com.imrahil.bbapps.morsegenerator.controller
{
    import com.imrahil.bbapps.morsegenerator.services.IPurchaseService;

    import org.robotlegs.mvcs.SignalCommand;

    public class PurchaseCommand extends SignalCommand
    {
        [Inject]
        public var purchaseService:IPurchaseService;

        override public function execute():void
        {
            purchaseService.purchase();
        }
    }
}
