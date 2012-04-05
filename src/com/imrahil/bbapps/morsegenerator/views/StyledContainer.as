/*
 Copyright (c) 2012 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
package com.imrahil.bbapps.morsegenerator.views
{
    import flash.text.TextFormat;

    import qnx.ui.core.Container;

    public class StyledContainer extends Container
    {
        protected var textFormat:TextFormat;

        public function StyledContainer(textFormat:TextFormat)
        {
            this.textFormat = textFormat;
        }
    }
}
