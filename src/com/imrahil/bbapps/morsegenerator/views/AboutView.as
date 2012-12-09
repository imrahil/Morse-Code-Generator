/*
 Copyright (c) 2012 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
package com.imrahil.bbapps.morsegenerator.views
{
    import com.imrahil.bbapps.morsegenerator.constants.Resources;

    import flash.desktop.NativeApplication;
    import flash.display.Bitmap;

    import qnx.fuse.ui.core.Container;
    import qnx.fuse.ui.core.SizeOptions;
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
            layout.numColumns = 1;
            layout.paddingLeft = 50;
            layout.paddingRight = 50;
            layout.paddingTop = 50;
            layout.paddingBottom = 30;
            container.layout = layout;

            var bg:Bitmap = new Resources.INFO_BG();
            container.background = bg;

            var infoLabel:Label = new Label();
            infoLabel.maxLines = 0;
            infoLabel.text = "Author: Jarek Szczepański\n" +
                    "Email: support_bb@imrahil.com\n" +
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

            content = container;
        }
    }
}
