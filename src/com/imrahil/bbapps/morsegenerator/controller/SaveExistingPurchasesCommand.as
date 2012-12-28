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

    import mx.collections.ArrayCollection;

    import org.robotlegs.mvcs.SignalCommand;

    public class SaveExistingPurchasesCommand extends SignalCommand
    {
        /** PARAMETERS **/
        [Inject]
        public var existingPurchases:Array;

        /** INJECTIONS **/
        [Inject]
        public var model:IMorseCodeModel;

        override public function execute():void
        {
            model.existingPurchases = existingPurchases;
        }
    }
}
