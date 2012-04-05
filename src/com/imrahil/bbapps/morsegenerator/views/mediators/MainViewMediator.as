/*
 Copyright (c) 2012 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
package com.imrahil.bbapps.morsegenerator.views.mediators
{
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

    public class MainViewMediator extends SignalMediator
    {
        [Inject]
        public var view:MainView;

        [Inject]
        public var startFlickerSignal:StartFlickerSignal;

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
        }

        public function onStartFlickerSignal(computedFlickerArray:Array):void
        {
            logger.debug(": onStartFlickerSignal");

            flickerPos = 0;

            flickerArray = computedFlickerArray;

            flickerTimer = new Timer(flickerArray[flickerPos].time, flickerArray.length - 1);
            flickerTimer.addEventListener(TimerEvent.TIMER, onFlickerTimer);
            flickerTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onFlickerTimerComplete);
            flickerTimer.start();

            flickerSprite = new Sprite();
            flickerSprite.addEventListener(MouseEvent.CLICK, onFlickClick);
            view.addChild(flickerSprite);

            flick(flickerArray[flickerPos].type == "*");

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

            flick(flickerArray[flickerPos].type == "*");

            var timer:Timer = event.currentTarget as Timer;
            timer.stop();
            timer.delay = flickerArray[flickerPos].time;
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

            flickerSprite.graphics.drawRect(0, 0, 1024, 600);
        }
    }
}
