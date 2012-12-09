/*
 Copyright (c) 2012 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
package com.imrahil.bbapps.morsegenerator.views
{
    import qnx.fuse.ui.core.Container;
    import qnx.fuse.ui.text.TextFormat;

    public class StyledContainer extends Container
    {
        protected var textFormat:TextFormat;

        public function StyledContainer(textFormat:TextFormat)
        {
            this.textFormat = textFormat;
        }
    }
}
