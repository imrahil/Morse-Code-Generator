package com.imrahil.bbapps.morsegenerator.views.mediators
{
    import com.imrahil.bbapps.morsegenerator.utils.LogUtil;
    import com.imrahil.bbapps.morsegenerator.views.MainView;

    import mx.logging.ILogger;

    import org.robotlegs.mvcs.Mediator;

    public class MainViewMediator extends Mediator
    {
        [Inject]
        public var view:MainView;

        /** variables **/
        private var logger:ILogger;

        public function MainViewMediator()
        {
            super();

            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        override public function onRegister():void
        {
            logger.debug(": onRegister");

        }
    }
}
