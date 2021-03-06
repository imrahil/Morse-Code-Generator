/*
 Copyright (c) 2013 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
package com.imrahil.bbapps.morsegenerator.utils
{
    import flash.utils.getQualifiedClassName;

    import mx.logging.ILogger;
    import mx.logging.Log;

    public class LogUtil
    {
        /**
         * Get a logger for
         */
        public static function getLogger(obj:Object):ILogger
        {
            return Log.getLogger(getQualifiedClassName(obj).replace("::", "."));
        }
    }
}
