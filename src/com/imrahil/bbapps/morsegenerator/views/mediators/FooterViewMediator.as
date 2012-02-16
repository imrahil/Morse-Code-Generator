package com.imrahil.bbapps.morsegenerator.views.mediators
{
    import com.imrahil.bbapps.morsegenerator.services.IMorseCodeService;
    import com.imrahil.bbapps.morsegenerator.signals.signaltons.SwitchFooterButtonsSignal;
    import com.imrahil.bbapps.morsegenerator.utils.LogUtil;
    import com.imrahil.bbapps.morsegenerator.views.FooterView;

    import mx.logging.ILogger;

    import org.robotlegs.mvcs.Mediator;

    public class FooterViewMediator extends Mediator
    {
        [Inject]
        public var view:FooterView;

        [Inject]
        public var morseCodeService:IMorseCodeService;

        [Inject]
        public var switchFooterButtonsSignal:SwitchFooterButtonsSignal;


        /** variables **/
        private var logger:ILogger;

        public function FooterViewMediator()
        {
            super();

            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        override public function onRegister():void
        {
            logger.debug(": onRegister");

            switchFooterButtonsSignal.add(onSwitchFooterButtons);

            view.longBeepClickSignal.add(onLongBeepBtnClicked);
            view.shortBeepClickSignal.add(onShortBeepBtnClicked);
        }

        private function onSwitchFooterButtons(state:Boolean):void
        {
            view.longBeepBtn.enabled = state;
            view.shortBeepBtn.enabled = state;
        }

        private function onLongBeepBtnClicked():void
        {
			logger.debug("onLongBeepBtnClick");

			morseCodeService.playString("T");
        }

        private function onShortBeepBtnClicked():void
        {
            logger.debug("onLongBeepBtnClick");

            morseCodeService.playString("E");
        }
    }
}
