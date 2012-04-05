/*
 Copyright (c) 2012 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
package com.imrahil.bbapps.morsegenerator.signals
{
    import org.osflash.signals.Signal;

    public class SetSpeedSignal extends Signal
    {
        public function SetSpeedSignal()
        {
            super(int);
        }
    }
}
