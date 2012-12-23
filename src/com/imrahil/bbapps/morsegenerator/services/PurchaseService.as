/*
 Copyright (c) 2012 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
package com.imrahil.bbapps.morsegenerator.services
{
    import com.imrahil.bbapps.morsegenerator.constants.ApplicationConstants;
    import com.imrahil.bbapps.morsegenerator.signals.SaveExistingPurchaseStatusSignal;
    import com.imrahil.bbapps.morsegenerator.signals.signaltons.ProvidePurchaseStatusSignal;
    import com.imrahil.bbapps.morsegenerator.utils.LogUtil;

    import flash.events.TimerEvent;

    import flash.net.SharedObject;
    import flash.utils.Timer;

    import mx.logging.ILogger;

    import net.rim.blackberry.events.PaymentErrorEvent;
    import net.rim.blackberry.events.PaymentSuccessEvent;
    import net.rim.blackberry.payment.PaymentSystem;

    public class PurchaseService implements IPurchaseService
    {
        [Inject]
        public var saveExistingPurchaseStatusSignal:SaveExistingPurchaseStatusSignal;

        private var paymentSystem:PaymentSystem;

        private var logger:ILogger;

        public function PurchaseService()
        {
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");

            paymentSystem = new PaymentSystem();
            paymentSystem.setConnectionMode(PaymentSystem.CONNECTION_MODE_LOCAL);
        }

        public function checkExistingPurchase():void
        {
            logger.debug(": checkExistingPurchase call");

            var sessionSO:SharedObject = SharedObject.getLocal(ApplicationConstants.PURCHASE_SO_NAME);

            if (sessionSO.data.purchased != undefined)
            {
                logger.debug(": SO exists");

                // uncomment to clear local shared object
//                sessionSO.clear();

                saveExistingPurchaseStatusSignal.dispatch(ApplicationConstants.PURCHASE_SUBSCRIPTION_EXIST);
            }
            else
            {
                logger.debug(": check online");

                paymentSystem.addEventListener(PaymentSuccessEvent.CHECK_EXISTING_SUCCESS, checkExisitingSuccessHandler);
                paymentSystem.addEventListener(PaymentErrorEvent.CHECK_EXISTING_ERROR, checkExisitingErrorHandler);
                paymentSystem.checkExisting(null, ApplicationConstants.PURCHASE_GOOD_ID);
            }
        }

        public function getPrice():void
        {
            logger.debug(": getPrice call");

            paymentSystem.addEventListener(PaymentSuccessEvent.GET_PRICE_SUCCESS, getPriceSuccessHandler);
            paymentSystem.addEventListener(PaymentErrorEvent.GET_PRICE_ERROR, getPriceErrorHandler)
        }

        public function purchase():void
        {
            logger.debug(": purchase call");

            paymentSystem.addEventListener(PaymentSuccessEvent.PURCHASE_SUCCESS, purchaseSuccessHandler);
            paymentSystem.addEventListener(PaymentErrorEvent.PURCHASE_ERROR, purchaseErrorHandler);
        }

        // handlers
        private function checkExisitingSuccessHandler(event:PaymentSuccessEvent):void
        {
            logger.debug(": checkExisitingSuccessHandler");

            paymentSystem.removeEventListener(PaymentSuccessEvent.CHECK_EXISTING_SUCCESS, checkExisitingSuccessHandler);
            paymentSystem.removeEventListener(PaymentErrorEvent.CHECK_EXISTING_ERROR, checkExisitingErrorHandler);

            if (event.subscriptionExists)
            {
                var sessionSO:SharedObject = SharedObject.getLocal(ApplicationConstants.PURCHASE_SO_NAME);
                sessionSO.data.purchased = event.purchase.purchaseID;
                sessionSO.flush();
            }

//            var timer:Timer = new Timer(3000, 1);
//            timer.addEventListener(TimerEvent.TIMER_COMPLETE, function(event:TimerEvent):void{
//                saveExistingPurchaseStatusSignal.dispatch(ApplicationConstants.PURCHASE_STATUS_YES);
//            });
//            timer.start();

            if (event.subscriptionExists)
            {
                saveExistingPurchaseStatusSignal.dispatch(ApplicationConstants.PURCHASE_SUBSCRIPTION_EXIST);
            }
            else
            {
                saveExistingPurchaseStatusSignal.dispatch(ApplicationConstants.PURCHASE_SUBSCRIPTION_NO);
            }
        }

        private function checkExisitingErrorHandler(event:PaymentErrorEvent):void
        {
            logger.debug(": checkExisitingErrorHandler");

            paymentSystem.removeEventListener(PaymentSuccessEvent.CHECK_EXISTING_SUCCESS, checkExisitingSuccessHandler);
            paymentSystem.removeEventListener(PaymentErrorEvent.CHECK_EXISTING_ERROR, checkExisitingErrorHandler);
        }

        private function getPriceSuccessHandler(event:PaymentSuccessEvent):void
        {

        }

        private function getPriceErrorHandler(event:PaymentErrorEvent):void
        {

        }

        private function purchaseSuccessHandler(event:PaymentSuccessEvent):void
        {

        }

        private function purchaseErrorHandler(event:PaymentErrorEvent):void
        {

        }
    }
}
