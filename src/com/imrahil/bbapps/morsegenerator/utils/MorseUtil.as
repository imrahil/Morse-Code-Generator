package com.imrahil.bbapps.morsegenerator.utils
{
    public class MorseUtil
    {
        public function MorseUtil()
        {
        }

        public static function isMorse(value:String):Boolean
        {
            var pattern:RegExp = /^[ \/.-]*$/g;
            var output:Boolean = pattern.test(value);

            return output;
        }
    }
}
