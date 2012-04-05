/*
 Copyright (c) 2012 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
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
