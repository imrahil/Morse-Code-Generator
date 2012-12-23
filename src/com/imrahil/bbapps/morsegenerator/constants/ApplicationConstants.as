/*
 Copyright (c) 2012 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
package com.imrahil.bbapps.morsegenerator.constants
{
    public class ApplicationConstants
    {
        public static const FACEBOOK_URL:String = "http://www.facebook.com/dialog/feed?app_id=273312749409209&link=http://www.facebook.com/imrahil&name=Morse%20Code%20Generator&caption=Post%20Morse%20code directly%20on%20your%20Facebook%20wall!&description=Message%20is%20in%20your%20clipboard.%20Just%20hit%20CTRL%2BV!&redirect_uri=http://www.facebook.com";
        public static const TWITTER_URL:String = "http://twitter.com/home?status=";
        public static const TWITTER_URL_COPY:String = " (encoded%20Morse%20code%20message)";

        public static const PURCHASE_SO_NAME:String = "morseCodePurchaseSharedObject";
        public static const PURCHASE_GOOD_ID:String = "morseEnableShare";

        public static const SPEED_ARRAY:Array = [4, 3, 2.5, 2, 1.5, 1.3, 1, 0.9, 0.8, 0.7];

        public static const SOUND_LENGTH:int        = 2400;
        public static const SILENCE_LENGTH:int      = 4800;

        public static const FLICKER_FACTOR:Number   = 0.07;

        public static const FLICKER_WHITE:String    = "*";
        public static const FLICKER_BLACK:String    = " ";

        public static const DIT:String              = ".";
        public static const DAH:String              = "-";
        public static const SPACE:String            = " ";

        public static const PURCHASE_SUBSCRIPTION_UNKNOWN:int   = -1;
        public static const PURCHASE_SUBSCRIPTION_NO:int        = 0;
        public static const PURCHASE_SUBSCRIPTION_EXIST:int     = 1;
    }
}
