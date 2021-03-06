/*
 Copyright (c) 2013 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
package com.imrahil.bbapps.morsegenerator.utils
{
    import qnx.fuse.ui.text.TextFormat;

    public class TextFormatUtil
    {
        public function TextFormatUtil()
        {
            super();
        }

        public static function setFormat(format:TextFormat, size:int = 54):TextFormat
        {
            format.size = size;
            format.color = 0xFAFAFA;
            format.italic = true;
            format.font = "Slate Pro Light";

            return format;
        }
    }
}
