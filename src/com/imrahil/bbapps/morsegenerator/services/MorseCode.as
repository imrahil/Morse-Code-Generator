package com.imrahil.bbapps.morsegenerator.services
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.SampleDataEvent;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.utils.ByteArray;

    public class MorseCode extends EventDispatcher implements IMorseCode
    {
        private static const SOUND_LENGTH:int = 2400;
        private static const SILENCE_LENGTH:int = 4800;
        private static const FLICKER_FACTOR:Number = 0.07;

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

        public var speed:Number = 1;

        private var soundChannel:SoundChannel;
        private var soundBytes:ByteArray;

        public var isPlaying:Boolean = false;

        public function MorseCode()
        {
            // rewrite all characters for
            for (var key:String in characters)
            {
                morseCharacters[characters[key]] = key;
            }
        }

        public function playString(string:String):void
        {
            var codeString:String = stringToCode(string);
            soundBytes = codeStringToBytes(codeString);

            soundBytes.position = 0;

            var codeSound:Sound = new Sound();
            codeSound.addEventListener(SampleDataEvent.SAMPLE_DATA, addSoundBytesToSound);
            soundChannel = codeSound.play();
            isPlaying = true;

            // event listener to handle sound complete and change UI
            soundChannel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
        }

        private function soundCompleteHandler(event:Event):void
        {
            isPlaying = false;
            dispatchEvent(event);
        }

        public function stop():void
        {
            soundChannel.stop();
            isPlaying = false;
            dispatchEvent(new Event(Event.SOUND_COMPLETE));
        }

        public function stringToCode(value:String):String
        {
            var returnString:String = "";
            var stringLength:int = value.length;

            for (var i:int = 0; i < stringLength; i++)
            {
                var stringChar:String = value.charAt(i);
                if (characters[stringChar] != undefined)
                {
                    returnString += characters[stringChar] + " ";
                }
                else
                {
                    returnString += " ";
                }
            }
            return returnString;
        }

        public function codeToString(code:String):String
        {
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
            var output:Array = [
                {type:" ", time:speed * SILENCE_LENGTH * FLICKER_FACTOR}
            ];
            var stringLength:int = value.length;

            for (var i:int = 0; i < stringLength; i++)
            {
                var morseChar:String = value.charAt(i);
                switch (morseChar)
                {
                    case "." :
                        output.push({type:"*", time:speed * SOUND_LENGTH * FLICKER_FACTOR});
                        output.push({type:" ", time:speed * SILENCE_LENGTH * FLICKER_FACTOR});
                        break;
                    case "-" :
                        output.push({type:"*", time:3 * speed * SOUND_LENGTH * FLICKER_FACTOR});
                        output.push({type:" ", time:speed * SILENCE_LENGTH * FLICKER_FACTOR});
                        break;
                    case " ":
                        output.push({type:" ", time:2 * speed * SILENCE_LENGTH * FLICKER_FACTOR});
                        break;
                    default :
                        output.push({type:" ", time:2 * speed * SILENCE_LENGTH * FLICKER_FACTOR});
                }
            }
            return output;
        }

        private function codeStringToBytes(value:String):ByteArray
        {
            var returnBytes:ByteArray = new ByteArray();
            var stringLength:int = value.length;

            for (var i:int = 0; i < stringLength; i++)
            {
                var morseChar:String = value.charAt(i);
                switch (morseChar)
                {
                    case "." :
                        returnBytes.writeBytes(sineWaveGenerator(speed))
                        returnBytes.writeBytes(silenceGenerator(speed));
                        break;
                    case "-" :
                        returnBytes.writeBytes(sineWaveGenerator(3 * speed));
                        returnBytes.writeBytes(silenceGenerator(speed));
                        break;
                    case " ":
                        returnBytes.writeBytes(silenceGenerator(2 * speed));
                        break;
                    default :
                        returnBytes.writeBytes(silenceGenerator(2 * speed));
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

        private static function sineWaveGenerator(length:Number):ByteArray
        {
            var returnBytes:ByteArray = new ByteArray();
            for (var i:int = 0; i < length * SOUND_LENGTH; i++)
            {
                var value:Number = Math.sin(i / 6) * 0.5;
                returnBytes.writeFloat(value);
                returnBytes.writeFloat(value);
            }
            return returnBytes;
        }

        private static function silenceGenerator(length:Number):ByteArray
        {
            var returnBytes:ByteArray = new ByteArray();
            for (var i:int = 0; i < length * SILENCE_LENGTH; i++)
            {
                returnBytes.writeFloat(0);
            }
            return returnBytes;
        }
    }
}
