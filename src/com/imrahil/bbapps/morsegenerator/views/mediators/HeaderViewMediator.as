package com.imrahil.bbapps.morsegenerator.views.mediators
{
    import com.imrahil.bbapps.morsegenerator.utils.LogUtil;
    import com.imrahil.bbapps.morsegenerator.views.HeaderView;

    import mx.logging.ILogger;

    import org.robotlegs.mvcs.Mediator;

    public class HeaderViewMediator extends Mediator
    {
        [Inject]
        public var view:HeaderView;

        /** variables **/
        private var logger:ILogger;

        public function HeaderViewMediator()
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
