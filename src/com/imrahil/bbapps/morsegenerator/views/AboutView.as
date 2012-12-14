/*
 Copyright (c) 2012 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
package com.imrahil.bbapps.morsegenerator.views
{
    import flash.desktop.NativeApplication;
    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;
    import flash.net.sendToURL;

    import qnx.fuse.ui.buttons.LabelButton;
    import qnx.fuse.ui.core.Container;
    import qnx.fuse.ui.core.SizeOptions;
    import qnx.fuse.ui.layouts.Align;
    import qnx.fuse.ui.layouts.gridLayout.GridData;
    import qnx.fuse.ui.layouts.gridLayout.GridLayout;
    import qnx.fuse.ui.text.Label;
    import qnx.fuse.ui.text.TextFormat;

    public class AboutView extends TitlePage
    {
        public function AboutView()
        {
            super();

            var app_xml:XML = NativeApplication.nativeApplication.applicationDescriptor;
            var ns:Namespace = app_xml.namespace();

            title = "Morse Code Generator - v." + app_xml.ns::versionNumber;
        }

        override protected function onAdded():void
        {
            super.onAdded();

            var container:Container = new Container();
            var layout:GridLayout = new GridLayout();
            layout.paddingLeft = 50;
            layout.paddingRight = 50;
            layout.paddingTop = 50;
            layout.paddingBottom = 30;
            container.layout = layout;

            var s:Sprite = new Sprite();
            var g:Graphics = s.graphics;
            g.beginFill(0x0c151c);
            g.drawRect(0, 0, 10, 10);
            g.endFill();

            container.background = s;

            var infoLabel:Label = new Label();
            infoLabel.maxLines = 0;
            infoLabel.text = "Author: Jarek Szczepański\n" +
                    "Email: support_bb@imrahil.com\n\n" +
                    "Website:\nhttp://imrahil.github.com/";

            var format:TextFormat = infoLabel.format;
            format.size = 54;
            format.color = 0xFAFAFA;
            format.italic = true;
            format.font = "Slate Pro Light";

            infoLabel.format = format;

            var labelData:GridData = new GridData();
            labelData.setOptions(SizeOptions.RESIZE_BOTH);
            infoLabel.layoutData = labelData;

            container.addChild(infoLabel);

            var visitBtn:LabelButton = new LabelButton();
            visitBtn.label = "Visit website";
            visitBtn.addEventListener(MouseEvent.CLICK, onVisitBtnClick);

            var visitBtnData:GridData = new GridData();
            visitBtnData.setOptions(SizeOptions.GROW_VERTICAL);
            visitBtnData.hAlign = Align.CENTER;
            visitBtnData.vAlign = Align.BEGIN;
            visitBtn.layoutData = visitBtnData;

            container.addChild(visitBtn);

            content = container;
        }

        private static function onVisitBtnClick(event:MouseEvent):void
        {
            navigateToURL(new URLRequest("http://imrahil.github.com"));
        }
    }
}
