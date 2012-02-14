package com.imrahil.bbapps.morsegenerator
{
    import com.imrahil.bbapps.morsegenerator.controller.*;
    import com.imrahil.bbapps.morsegenerator.model.*;
    import com.imrahil.bbapps.morsegenerator.services.*;
    import com.imrahil.bbapps.morsegenerator.signals.*;
    import com.imrahil.bbapps.morsegenerator.signals.signaltons.*;
    import com.imrahil.bbapps.morsegenerator.views.*;
    import com.imrahil.bbapps.morsegenerator.views.mediators.*;

    import flash.display.DisplayObjectContainer;

    import org.robotlegs.mvcs.SignalContext;

    public class MorseCodeGeneratorContext extends SignalContext

    {
        public function MorseCodeGeneratorContext(contextView:DisplayObjectContainer = null)
        {
            super(contextView, true);
        }

        override public function startup():void
        {
            // Add Signals + Signaltons
            signalCommandMap.mapSignalClass(TranslateSignal, TranslateCommand);
            signalCommandMap.mapSignalClass(ComputeFlickerSignal, ComputeFlickerCommand);
            signalCommandMap.mapSignalClass(SetSpeedSignal, SetSpeedCommand);

            injector.mapSingleton(StartFlickerSignal);
            injector.mapSingleton(UpdateOutputSignal);
            injector.mapSingleton(SwitchRightSideButtonsSignal);


            // Add Model
            injector.mapSingletonOf(IMorseCodeModel, MorseCodeModel);

            // Add Services
            injector.mapSingletonOf(IMorseCodeService, MorseCodeService);

            // Add View + View Mediators
            mediatorMap.mapView(HeaderView, HeaderViewMediator);
            mediatorMap.mapView(FooterView, FooterViewMediator);

            mediatorMap.mapView(LeftContainer, LeftContainerMediator);
            mediatorMap.mapView(RightContainer, RightContainerMediator);

            mediatorMap.mapView(MainView, MainViewMediator);


            addRootView();

            super.startup();
        }

        protected function addRootView():void
        {
            var mainView:MainView = new MainView();
            contextView.addChild(mainView);
        }
    }
}
