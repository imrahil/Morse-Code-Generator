package com.imrahil.bbapps.morsegenerator.controller
{
    import com.imrahil.bbapps.morsegenerator.constants.ApplicationConstants;
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
            morseCodeService.speed = ApplicationConstants.SPEED_ARRAY[speed];
        }
    }
}
