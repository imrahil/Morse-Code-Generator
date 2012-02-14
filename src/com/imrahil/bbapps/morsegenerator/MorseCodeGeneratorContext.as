package com.imrahil.bbapps.morsegenerator
{
    import com.imrahil.bbapps.morsegenerator.services.IMorseCode;
    import com.imrahil.bbapps.morsegenerator.services.MorseCode;
    import com.imrahil.bbapps.morsegenerator.views.FooterView;
    import com.imrahil.bbapps.morsegenerator.views.MainView;
    import com.imrahil.bbapps.morsegenerator.views.mediators.FooterViewMediator;
    import com.imrahil.bbapps.morsegenerator.views.mediators.MainViewMediator;

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
            // Add Model


            // Add Services
            injector.mapSingletonOf(IMorseCode, MorseCode);

            // Add View + View Mediators
            mediatorMap.mapView(FooterView, FooterViewMediator);
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
