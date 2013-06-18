/*
 Copyright (c) 2013 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
package com.imrahil.bbapps.morsegenerator.model.vo
{
    public class FlickerVO
    {
        public var type:String;
        public var time:Number;

        public function FlickerVO(type:String, time:Number)
        {
            this.type = type;
            this.time = time;
        }
    }
}
