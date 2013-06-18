/*
 Copyright (c) 2013 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
package com.imrahil.bbapps.morsegenerator.views.mediators
{
    import com.imrahil.bbapps.morsegenerator.constants.ApplicationConstants;
    import com.imrahil.bbapps.morsegenerator.model.vo.FlickerVO;
    import com.imrahil.bbapps.morsegenerator.signals.GetExistingPurchasesSignal;
    import com.imrahil.bbapps.morsegenerator.signals.signaltons.PurchaseErrorSignal;
    import com.imrahil.bbapps.morsegenerator.signals.signaltons.StartFlickerSignal;
    import com.imrahil.bbapps.morsegenerator.utils.LogUtil;
    import com.imrahil.bbapps.morsegenerator.views.MainView;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    import mx.logging.ILogger;

    import org.robotlegs.mvcs.SignalMediator;

    import qnx.fuse.ui.dialog.AlertDialog;

    public class MainViewMediator extends SignalMediator
    {
        [Inject]
        public var view:MainView;

        [Inject]
        public var startFlickerSignal:StartFlickerSignal;

        [Inject]
        public var getExistingPurchasesSignal:GetExistingPurchasesSignal;

        [Inject]
        public var purchaseErrorSignal:PurchaseErrorSignal;

        /** variables **/
        private var logger:ILogger;

        private var flickerArray:Array = [];
        private var flickerPos:int = 0;
        private var flickerSprite:Sprite;
        private var flickerTimer:Timer;

        public function MainViewMediator()
        {
            super();

            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        override public function onRegister():void
        {
            logger.debug(": onRegister");

            addToSignal(startFlickerSignal, onStartFlickerSignal);
            addToSignal(purchaseErrorSignal, onPurchaseErrorSignal);

            getExistingPurchasesSignal.dispatch();
        }

        public function onStartFlickerSignal(computedFlickerArray:Array):void
        {
            logger.debug(": onStartFlickerSignal");

            flickerPos = 0;

            flickerArray = computedFlickerArray;
            var flickerVO:FlickerVO = flickerArray[flickerPos] as FlickerVO;

            flickerTimer = new Timer(flickerVO.time, flickerArray.length - 1);
            flickerTimer.addEventListener(TimerEvent.TIMER, onFlickerTimer);
            flickerTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onFlickerTimerComplete);
            flickerTimer.start();

            flickerSprite = new Sprite();
            flickerSprite.addEventListener(MouseEvent.CLICK, onFlickClick);
            view.addChild(flickerSprite);

            flick(flickerVO.type == ApplicationConstants.FLICKER_WHITE);

            flickerPos++;
        }

        protected function onFlickClick(event:MouseEvent):void
        {
            logger.debug(": onFlickClick");

            flickerTimer.stop();
            flickerTimer.removeEventListener(TimerEvent.TIMER, onFlickerTimer);
            flickerTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onFlickerTimerComplete);
            flickerTimer = null;

            view.removeChild(flickerSprite);
        }

        private function onFlickerTimer(event:Event):void
        {
            logger.debug(": onFlickerTimer");

            var flickerVO:FlickerVO = flickerArray[flickerPos] as FlickerVO;

            flick(flickerVO.type == ApplicationConstants.FLICKER_WHITE);

            var timer:Timer = event.currentTarget as Timer;
            timer.stop();
            timer.delay = flickerVO.time;

            flickerPos++;
            timer.start();
        }

        private function onFlickerTimerComplete(event:TimerEvent):void
        {
            logger.debug(": onFlickerTimerComplete");

            if (flickerSprite && view.contains(flickerSprite))
            {
                view.removeChild(flickerSprite);
            }
        }

        private function flick(mode:Boolean = true):void
        {
            if (mode)
            {
                flickerSprite.graphics.beginFill(0xFFFFFF);
            }
            else
            {
                flickerSprite.graphics.beginFill(0x000000);
            }

            flickerSprite.graphics.drawRect(0, 0, view.stage.stageWidth, view.stage.stageHeight);
        }

        private function onPurchaseErrorSignal(message:String):void
        {
            var errorDialog:AlertDialog = new AlertDialog();
            errorDialog.title = "Something bad happend...";
            errorDialog.message = message;
            errorDialog.addButton("OK");
            errorDialog.show();
        }
    }
}
