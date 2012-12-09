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
    import com.imrahil.bbapps.morsegenerator.model.vo.FlickerVO;
    import com.imrahil.bbapps.morsegenerator.utils.LogUtil;

    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.SampleDataEvent;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.utils.ByteArray;

    import mx.logging.ILogger;

    import org.bytearray.micrecorder.encoder.IEncoder;
    import org.osflash.signals.Signal;

    public class MorseCodeService extends EventDispatcher implements IMorseCodeService
    {
        [Inject]
        public var encoder:IEncoder;

        private static var characters:Array = [];
        private static var morseCharacters:Array = [];

        characters["A"] = ".-";
        characters["B"] = "-...";
        characters["C"] = "-.-.";
        characters["D"] = "-..";
        characters["E"] = ".";
        characters["F"] = "..-.";
        characters["G"] = "--.";
        characters["H"] = "....";
        characters["I"] = "..";
        characters["J"] = ".---";
        characters["K"] = "-.-";
        characters["L"] = ".-..";
        characters["M"] = "--";
        characters["N"] = "-.";
        characters["O"] = "---";
        characters["P"] = ".--.";
        characters["Q"] = "--.-";
        characters["R"] = ".-.";
        characters["S"] = "...";
        characters["T"] = "-";
        characters["U"] = "..-";
        characters["V"] = "...-";
        characters["W"] = ".--";
        characters["X"] = "-..-";
        characters["Y"] = "-.--";
        characters["Z"] = "--..";
        characters["1"] = ".----";
        characters["2"] = "..---";
        characters["3"] = "...--";
        characters["4"] = "....-";
        characters["5"] = ".....";
        characters["6"] = "-....";
        characters["7"] = "--...";
        characters["8"] = "---..";
        characters["9"] = "----.";
        characters["0"] = "-----";
        characters["."] = ".-.-.-";
        characters[","] = "--..--";
        characters[":"] = "---...";
        characters["?"] = "..--..";
        characters["\'"] = ".----.";
        characters["-"] = "-....-";
        characters["/"] = "-..-.";
        characters["("] = "-.--.-";
        characters[")"] = "-.--.-";
        characters["\""] = ".-..-.";
        characters["@"] = ".--.-.";
        characters["="] = "-...-";
        characters[" "] = "/";


        private var soundChannel:SoundChannel;
        private var soundBytes:ByteArray;
        private var _speed:Number = 1;

        private var _isPlaying:Boolean = false;

        private var _soundCompleteSignal:Signal = new Signal();

        private var logger:ILogger;

        public function MorseCodeService()
        {
            // rewrite all characters for
            for (var key:String in characters)
            {
                morseCharacters[characters[key]] = key;
            }

            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        public function set speed(newSpeed:Number):void
        {
            logger.debug(": set speed: " + newSpeed);

            _speed = newSpeed;
        }

        public function get isPlaying():Boolean
        {
            return _isPlaying;
        }

        public function get soundCompleteSignal():Signal
        {
            return _soundCompleteSignal;
        }

        public function playString(morseCode:String):void
        {
            logger.debug(": playString: " + morseCode);

            soundBytes = codeStringToBytes(morseCode);
            soundBytes.position = 0;

            var codeSound:Sound = new Sound();
            codeSound.addEventListener(SampleDataEvent.SAMPLE_DATA, addSoundBytesToSound);
            soundChannel = codeSound.play();
            _isPlaying = true;

            // event listener to handle sound complete and change UI
            soundChannel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
        }

        public function stop():void
        {
            logger.debug(": stop");

            soundChannel.stop();
            _isPlaying = false;
            dispatchEvent(new Event(Event.SOUND_COMPLETE));
        }

        public function stringToCode(value:String):String
        {
            logger.debug(": stringToCode: " + value);

            var returnString:String = "";
            var stringLength:int = value.length;

            for (var i:int = 0; i < stringLength; i++)
            {
                var stringChar:String = value.charAt(i);
                if (characters[stringChar] != undefined)
                {
                    returnString += characters[stringChar];
                }

                if (i + 1 < stringLength)
                {
                    returnString += " ";
                }
            }
            return returnString;
        }

        public function codeToString(code:String):String
        {
            logger.debug(": codeToString: " + code);

            var returnString:String = "";

            var morseArray:Array = code.split(" ");
            var morseArrayLength:int = morseArray.length;

            for (var x:int = 0; x < morseArrayLength; x++)
            {
                var morseCode:String = morseArray[x];
                if (morseCharacters[morseCode] != undefined)
                {
                    returnString += morseCharacters[morseCode];
                }
                else
                {
                    returnString += " ";
                }
            }

            return returnString;
        }

        public function codeStringToTimes(value:String):Array
        {
            logger.debug(": codeStringToTimes: " + value);

            var output:Array = [new FlickerVO(ApplicationConstants.FLICKER_BLACK, _speed * ApplicationConstants.SILENCE_LENGTH * ApplicationConstants.FLICKER_FACTOR)];
            var stringLength:int = value.length;

            for (var i:int = 0; i < stringLength; i++)
            {
                var morseChar:String = value.charAt(i);
                switch (morseChar)
                {
                    case ApplicationConstants.DIT:
                        output.push(new FlickerVO(ApplicationConstants.FLICKER_WHITE, _speed * ApplicationConstants.SOUND_LENGTH * ApplicationConstants.FLICKER_FACTOR));
                        output.push(new FlickerVO(ApplicationConstants.FLICKER_BLACK, _speed * ApplicationConstants.SILENCE_LENGTH * ApplicationConstants.FLICKER_FACTOR));
                        break;
                    case ApplicationConstants.DAH:
                        output.push(new FlickerVO(ApplicationConstants.FLICKER_WHITE, 3 * _speed * ApplicationConstants.SOUND_LENGTH * ApplicationConstants.FLICKER_FACTOR));
                        output.push(new FlickerVO(ApplicationConstants.FLICKER_BLACK, _speed * ApplicationConstants.SILENCE_LENGTH * ApplicationConstants.FLICKER_FACTOR));
                        break;
                    case ApplicationConstants.SPACE:
                        output.push(new FlickerVO(ApplicationConstants.FLICKER_BLACK, 2 * _speed * ApplicationConstants.SILENCE_LENGTH * ApplicationConstants.FLICKER_FACTOR));
                        break;
                    default:
                        output.push(new FlickerVO(ApplicationConstants.FLICKER_BLACK, 2 * _speed * ApplicationConstants.SILENCE_LENGTH * ApplicationConstants.FLICKER_FACTOR));
                }
            }
            return output;
        }

        public function saveAsWav(morseCode:String):ByteArray
        {
            logger.debug(": saveAsWav");

            soundBytes = codeStringToBytes(morseCode);
            soundBytes.position = 0;

            return encoder.encode(soundBytes);
        }


        /*
         *
         *   PRIVATE METHODS
         *
         */
        private function codeStringToBytes(value:String):ByteArray
        {
            var returnBytes:ByteArray = new ByteArray();
            var stringLength:int = value.length;

            for (var i:int = 0; i < stringLength; i++)
            {
                var morseChar:String = value.charAt(i);
                switch (morseChar)
                {
                    case ApplicationConstants.DIT:
                        returnBytes.writeBytes(sineWaveGenerator(_speed))
                        returnBytes.writeBytes(silenceGenerator(_speed));
                        break;
                    case ApplicationConstants.DAH:
                        returnBytes.writeBytes(sineWaveGenerator(3 * _speed));
                        returnBytes.writeBytes(silenceGenerator(_speed));
                        break;
                    case ApplicationConstants.SPACE:
                        returnBytes.writeBytes(silenceGenerator(2 * _speed));
                        break;
                    default:
                        returnBytes.writeBytes(silenceGenerator(2 * _speed));
                }
            }
            return returnBytes;
        }

        private function addSoundBytesToSound(event:SampleDataEvent):void
        {
            var bytes:ByteArray = new ByteArray();
            soundBytes.readBytes(bytes, 0, Math.min(soundBytes.bytesAvailable, 8 * 8192));
            event.data.writeBytes(bytes, 0, bytes.length);
        }

        private function soundCompleteHandler(event:Event):void
        {
            soundBytes.position = 0;

            _isPlaying = false;
            _soundCompleteSignal.dispatch();
        }

        /**
        * Generates sine wave audio data of a specified length. A short Morse code character (".")
        * has lenth == 1, generating a sine wave of 2000 samples. A long Morse code character ("-")
        * has lenth == 3, generating a sine wave of 6000 samples.
        */
        private static function sineWaveGenerator(length:Number):ByteArray
        {
            var returnBytes:ByteArray = new ByteArray();
            for (var i:int = 0; i < length * ApplicationConstants.SOUND_LENGTH; i++)
            {
                var value:Number = Math.sin(i / 6) * 0.4;
                returnBytes.writeFloat(value);
                returnBytes.writeFloat(value);
            }
            return returnBytes;
        }

        /**
        * Generates silent audio data of a specified length.
        */
        private static function silenceGenerator(length:Number):ByteArray
        {
            var returnBytes:ByteArray = new ByteArray();
            for (var i:int = 0; i < length * ApplicationConstants.SILENCE_LENGTH; i++)
            {
                returnBytes.writeFloat(0);
            }
            return returnBytes;
        }
    }
}
