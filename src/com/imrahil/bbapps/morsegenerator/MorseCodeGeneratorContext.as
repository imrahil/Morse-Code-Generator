/*
 Copyright (c) 2012 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
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

    import org.bytearray.micrecorder.encoder.IEncoder;
    import org.bytearray.micrecorder.encoder.WaveEncoder;

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
            signalCommandMap.mapSignalClass(MorseCodePlaySignal, MorseCodePlayCommand);
            signalCommandMap.mapSignalClass(CopyClipboardSignal, CopyClipboardCommand);

            signalCommandMap.mapSignalClass(SaveAsWavSignal, SaveAsWavCommand);
            signalCommandMap.mapSignalClass(SaveAsMp3Signal, SaveAsMp3Command);

            injector.mapSingleton(StartFlickerSignal);
            injector.mapSingleton(UpdateOutputSignal);

            injector.mapSingleton(SwitchRightSideButtonsSignal);
            injector.mapSingleton(SwitchFooterButtonsSignal);

            injector.mapSingleton(SwitchMorseCodePlaySignal);

            injector.mapSingleton(CodeCopiedIntoClipboardSignal);

            injector.mapSingleton(Mp3EncoderStatusSignal);


            // Add Model
            injector.mapSingletonOf(IMorseCodeModel, MorseCodeModel);

            // Add Services
            injector.mapSingletonOf(IMorseCodeService, MorseCodeService);
            injector.mapSingletonOf(IEncoder, WaveEncoder);

            // Add View + View Mediators
//            mediatorMap.mapView(HeaderView, HeaderViewMediator);
//            mediatorMap.mapView(FooterView, FooterViewMediator);
//
//            mediatorMap.mapView(LeftContainer, LeftContainerMediator);
//            mediatorMap.mapView(RightContainer, RightContainerMediator);
//
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
