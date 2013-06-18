/*
 Copyright (c) 2013 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
package com.imrahil.bbapps.morsegenerator.services
{
    public interface IPurchaseService
    {
        function checkExistingPurchase():void;
        function getExistingPurchases():void;
        function getPrice():void;
        function purchase():void;
    }
}
