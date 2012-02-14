package
{
    import com.imrahil.bbapps.morsegenerator.MorseCodeGeneratorContext;
    import com.imrahil.bbapps.morsegenerator.services.MorseCode;

    import flash.display.Sprite;
    import flash.utils.Timer;

    [SWF(width="1024", height="600", backgroundColor="#0D1722", frameRate="30")]
	public class MorseCodeGenerator extends Sprite
	{
        protected var _context:MorseCodeGeneratorContext;

		private var speedArray:Array = [3, 2.5, 2, 1.5, 1.3, 1, 0.9, 0.8, 0.7];
		
		private var flickerArray:Array = [];
		private var flickerPos:int = 0;
		private var flickerSprite:Sprite;
		private var flickerTimer:Timer;

		public function MorseCodeGenerator()
		{
            _context = new MorseCodeGeneratorContext(this);
		}
		
//		private function onInputChange(event:Event):void
//		{
//			logger.info("onInputChange");
//
//			if (left.translateBtn.enabled)
//			{
//				return;
//			}
//
//			if (left.inputValue == "")
//			{
//				right.playBtn.enabled = false;
//				right.flickerBtn.enabled = false;
//			}
//			else
//			{
//				right.playBtn.enabled = true;
//				right.flickerBtn.enabled = true;
//			}
//
//			if (!isMorse(left.inputValue))
//			{
//				translateTextToMorse(left.inputValue);
//			}
//			else
//			{
//				translateMorseToText(left.inputValue);
//			}
//		}
//
//		private function onTranslateClick(event:MouseEvent):void
//		{
//			logger.info("onTranslateClick");
//
//			if (!isMorse(left.inputValue))
//			{
//				translateTextToMorse(left.inputValue);
//			}
//			else
//			{
//				translateMorseToText(left.inputValue);
//			}
//		}
//
//		private function translateTextToMorse(value:String):void
//		{
//			logger.info("translateTextToMorse");
//
//			right.changeOutput(morseAlphabet.stringToCode(value));
//		}
//
//		private function translateMorseToText(value:String):void
//		{
//			logger.info("translateMorseToText");
//
//			right.changeOutput(morseAlphabet.codeToString(value));
//		}
//
//		private function onPlayBtnClick(event:MouseEvent):void
//		{
//			logger.info("onPlayBtnClick");
//
//			if (isMorse(left.inputValue))
//			{
//				right.playBtn.selected = false;
//				return;
//			}
//
//			if(morseAlphabet.isPlaying)
//			{
//				morseAlphabet.stop();
//
//				right.playBtn.label = "PLAY";
//
//				footer.longBeepBtn.enabled = true;
//				footer.shortBeepBtn.enabled = true;
//			}
//			else
//			{
//				right.playBtn.label = "STOP";
//
//				footer.longBeepBtn.enabled = false;
//				footer.shortBeepBtn.enabled = false;
//
//				morseAlphabet.playString(left.inputValue);
//
//				morseAlphabet.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
//
//				this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
//			}
//		}
//
//		private function onFlickerBtnClick(event:MouseEvent):void
//		{
//			logger.info("onFlickerBtnClick");
//
//			// do nothing if input string is Morse code
//			if (isMorse(left.inputValue))
//			{
//				return;
//			}
//
//			flickerPos = 0;
//
//			var flickerCodeString:String = morseAlphabet.stringToCode(left.inputValue);
//			flickerArray = morseAlphabet.codeStringToTimes(flickerCodeString);
//
//			flickerTimer = new Timer(flickerArray[flickerPos].time, flickerArray.length - 1);
//			flickerTimer.addEventListener(TimerEvent.TIMER, onFlickerTimer);
//			flickerTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onFlickerTimerComplete);
//			flickerTimer.start();
//
//			flickerSprite = new Sprite();
//			flickerSprite.addEventListener(MouseEvent.CLICK, onFlickClick);
//			this.addChild(flickerSprite);
//
//			flick(flickerArray[flickerPos].type == "*");
//
//			flickerPos++;
//		}
//
//		protected function onFlickClick(event:MouseEvent):void
//		{
//			flickerTimer.stop();
//			flickerTimer.removeEventListener(TimerEvent.TIMER, onFlickerTimer);
//			flickerTimer = null;
//
//			this.removeChild(flickerSprite);
//		}
//
//		private function onFlickerTimer(event:Event):void
//		{
//			flick(flickerArray[flickerPos].type == "*");
//
//			var timer:Timer = event.currentTarget as Timer;
//			timer.stop();
//			timer.delay = flickerArray[flickerPos].time;
//			flickerPos++;
//			timer.start();
//		}
//
//		private function onFlickerTimerComplete(event:TimerEvent):void
//		{
//			if (flickerSprite && this.contains(flickerSprite))
//			{
//				this.removeChild(flickerSprite);
//			}
//		}
//
//		private function flick(mode:Boolean = true):void
//		{
//			if (mode)
//			{
//				flickerSprite.graphics.beginFill(0xFFFFFF);
//			}
//			else
//			{
//				flickerSprite.graphics.beginFill(0x000000);
//			}
//			flickerSprite.graphics.drawRect(0, 0, 1024, 600);
//		}
//
//		private function onEnterFrame(event:Event):void
//		{
//			var spectrum:ByteArray = new ByteArray();
//			SoundMixer.computeSpectrum(spectrum);
//
//			right.mySpectrumGraph.fillRect(right.mySpectrumGraph.rect, 0x00000000);
//
//			for(var i:int=0; i < 256; i++)
//			{
//				right.mySpectrumGraph.setPixel32(i, 22 + spectrum.readFloat() * 30, 0xffffffff);
//			}
//		}
//
//		private function onSoundComplete(event:Event):void
//		{
//			logger.info("onSoundComplete");
//
//			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
//
//			right.mySpectrumGraph.fillRect(right.mySpectrumGraph.rect, 0x0D1722);
//
//			right.playBtn.label = "PLAY";
//			right.playBtn.selected = false;
//
//			footer.longBeepBtn.enabled = true;
//			footer.shortBeepBtn.enabled = true;
//		}
//
//		private function isMorse(value:String):Boolean
//		{
//			var pattern:RegExp = /^[ \/.-]*$/g;
//			var output:Boolean = pattern.test(value);
//
////			logger.info("isMorse - " + output);
//
//			return output;
//		}
//
//		private function speedSlider_moveHandler(event:SliderEvent):void
//		{
//			var speedValue:int = Math.round(event.value);
//			left.speedSlider.value = speedValue;
//			morseAlphabet.speed = speedArray[speedValue];
//		}
	}
}
