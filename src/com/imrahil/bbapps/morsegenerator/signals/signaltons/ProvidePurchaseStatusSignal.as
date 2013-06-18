/*
 Copyright (c) 2013 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
package com.imrahil.bbapps.morsegenerator.signals.signaltons
{
    import org.osflash.signals.Signal;

    public class ProvidePurchaseStatusSignal extends Signal
    {
        public function ProvidePurchaseStatusSignal()
        {
            super(int);
        }
    }
}
