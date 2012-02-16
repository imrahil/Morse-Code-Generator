package com.imrahil.bbapps.morsegenerator.controller
{
    import com.imrahil.bbapps.morsegenerator.services.IMorseCodeService;

    import org.robotlegs.mvcs.SignalCommand;

    public class SetSpeedCommand extends SignalCommand
    {
        /** PARAMETERS **/
        [Inject]
        public var speed:int;

        /** INJECTIONS **/
        [Inject]
        public var morseCodeService:IMorseCodeService;

        override public function execute():void
        {
            var speedArray:Array = [4, 3, 2.5, 2, 1.5, 1.3, 1, 0.9, 0.8, 0.7];

            morseCodeService.speed = speedArray[speed];
        }
    }
}
