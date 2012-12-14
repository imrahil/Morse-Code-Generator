/*
 Copyright (c) 2012 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
package com.imrahil.bbapps.morsegenerator.controller
{
    import com.imrahil.bbapps.morsegenerator.constants.ApplicationConstants;
    import com.imrahil.bbapps.morsegenerator.services.IMorseCodeService;
    import com.imrahil.bbapps.morsegenerator.signals.signaltons.ProvidePlaySpeedValueSignal;

    import org.robotlegs.mvcs.SignalCommand;

    public class ProvidePlaySpeedCommand extends SignalCommand
    {
        [Inject]
        public var morseCodeService:IMorseCodeService;

        [Inject]
        public var providePlaySpeedValue:ProvidePlaySpeedValueSignal;

        override public function execute():void
        {
            var speedValue:int = ApplicationConstants.SPEED_ARRAY.indexOf(morseCodeService.speed);
            providePlaySpeedValue.dispatch(speedValue);
        }
    }
}
