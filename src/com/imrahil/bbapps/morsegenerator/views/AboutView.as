/*
 Copyright (c) 2013 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
package com.imrahil.bbapps.morsegenerator.views
{
    import com.imrahil.bbapps.morsegenerator.utils.TextFormatUtil;

    import flash.desktop.NativeApplication;
    import flash.events.MouseEvent;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;

    import qnx.fuse.ui.buttons.LabelButton;
    import qnx.fuse.ui.core.Container;
    import qnx.fuse.ui.core.SizeOptions;
    import qnx.fuse.ui.layouts.Align;
    import qnx.fuse.ui.layouts.gridLayout.GridData;
    import qnx.fuse.ui.layouts.gridLayout.GridLayout;
    import qnx.fuse.ui.text.Label;

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
            layout.paddingLeft = 30;
            layout.paddingRight = 30;
            layout.paddingTop = 30;
            layout.paddingBottom = 30;
            container.layout = layout;

            var infoLabel:Label = new Label();
            infoLabel.maxLines = 0;
            infoLabel.text = "Author: Jarek Szczepański\n" +
                    "Email: support_bb@imrahil.com\n\n" +
                    "Website:\nhttp://imrahil.github.com/";

            infoLabel.format = TextFormatUtil.setFormat(infoLabel.format);

            var labelData:GridData = new GridData();
            labelData.setOptions(SizeOptions.RESIZE_BOTH);
            infoLabel.layoutData = labelData;

            container.addChild(infoLabel);

            var visitBtn:LabelButton = new LabelButton();
            visitBtn.label = "Visit website";
            visitBtn.addEventListener(MouseEvent.CLICK, onVisitBtnClick);

            var visitBtnData:GridData = new GridData();
            visitBtnData.setOptions(SizeOptions.GROW_VERTICAL);
            visitBtnData.preferredWidth = 300;
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
