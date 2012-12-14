/*
 Copyright (c) 2012 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
package com.imrahil.bbapps.morsegenerator.views.mediators
{
    import com.imrahil.bbapps.morsegenerator.services.IMorseCodeService;
    import com.imrahil.bbapps.morsegenerator.signals.signaltons.SwitchFooterButtonsSignal;
    import com.imrahil.bbapps.morsegenerator.utils.LogUtil;
    import com.imrahil.bbapps.morsegenerator.views.HelpView;

    import mx.logging.ILogger;

    import org.robotlegs.mvcs.SignalMediator;

    public class HelpViewMediator extends SignalMediator
    {
        [Inject]
        public var view:HelpView;

        [Inject]
        public var morseCodeService:IMorseCodeService;

        [Inject]
        public var switchFooterButtonsSignal:SwitchFooterButtonsSignal;


        /** variables **/
        private var logger:ILogger;

        public function HelpViewMediator()
        {
            super();

            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        override public function onRegister():void
        {
            logger.debug(": onRegister");

            addToSignal(switchFooterButtonsSignal, onSwitchFooterButtons);

            addToSignal(view.longBeepClickSignal, onLongBeepBtnClicked);
            addToSignal(view.shortBeepClickSignal, onShortBeepBtnClicked);
        }

        private function onSwitchFooterButtons(state:Boolean):void
        {
            view.longBeepBtn.enabled = state;
            view.shortBeepBtn.enabled = state;
        }

        private function onLongBeepBtnClicked():void
        {
            logger.debug("onLongBeepBtnClick");

            morseCodeService.playString("-");
        }

        private function onShortBeepBtnClicked():void
        {
            logger.debug("onLongBeepBtnClick");

            morseCodeService.playString(".");
        }
    }
}
