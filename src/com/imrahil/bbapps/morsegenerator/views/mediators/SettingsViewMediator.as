/*
 Copyright (c) 2013 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
package com.imrahil.bbapps.morsegenerator.views.mediators
{
    import com.imrahil.bbapps.morsegenerator.signals.RequestPlaySpeedValueSignal;
    import com.imrahil.bbapps.morsegenerator.signals.SetSpeedSignal;
    import com.imrahil.bbapps.morsegenerator.signals.signaltons.ProvidePlaySpeedValueSignal;
    import com.imrahil.bbapps.morsegenerator.utils.LogUtil;
    import com.imrahil.bbapps.morsegenerator.views.SettingsView;

    import mx.logging.ILogger;

    import org.robotlegs.mvcs.SignalMediator;

    import qnx.system.AudioManager;
    import qnx.system.AudioOutput;

    public class SettingsViewMediator extends SignalMediator
    {
        [Inject]
        public var view:SettingsView;

        [Inject]
        public var setSpeedSignal:SetSpeedSignal;

        [Inject]
        public var requestPlaySpeedValue:RequestPlaySpeedValueSignal;

        [Inject]
        public var providePlaySpeedValue:ProvidePlaySpeedValueSignal;

        /** variables **/
        private var logger:ILogger;

        public function SettingsViewMediator()
        {
            super();

            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        override public function onRegister():void
        {
            logger.debug(": onRegister");

            addToSignal(view.volumeSliderSignal, onVolumeSliderMoved);
            addToSignal(view.speedSliderSignal, onSpeedSliderMoved);
            addToSignal(view.viewAddedSignal, onViewAdded);

            addToSignal(providePlaySpeedValue, onProvidePlaySpeedValue);
        }

        private function onViewAdded():void
        {
            requestPlaySpeedValue.dispatch();
        }

        private function onProvidePlaySpeedValue(value:Number):void
        {
            if (view && view.speedSlider)
            {
                view.speedSlider.value = value;
            }
        }

        private function onVolumeSliderMoved(volume:Number):void
        {
            CONFIG::device
            {
                AudioManager.audioManager.setOutputLevel(volume, AudioOutput.SPEAKERS);
            }
        }

        private function onSpeedSliderMoved(newSpeed:int):void
        {
            setSpeedSignal.dispatch(newSpeed);
        }
    }
}
