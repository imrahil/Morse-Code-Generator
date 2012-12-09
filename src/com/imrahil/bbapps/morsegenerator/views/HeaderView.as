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
    import flash.events.Event;
    import flash.events.MouseEvent;

    import qnx.fuse.ui.buttons.IconButton;
    import qnx.fuse.ui.dialog.AlertDialog;
    import qnx.fuse.ui.display.Image;
    import qnx.fuse.ui.text.TextFormat;

    public class HeaderView
    {
        private var aboutDialog:AlertDialog;
        private var versionNumber:String;

        public function HeaderView(format:TextFormat)
        {
            super(format);
        }

        private function create(event:Event):void
        {
            var app_xml:XML = NativeApplication.nativeApplication.applicationDescriptor;
            var ns:Namespace = app_xml.namespace();
            versionNumber = app_xml.ns::versionNumber;

//            this.margins = Vector.<Number>([15, 0, 10, 10]);
//            this.size = 70;
//            this.sizeUnit = SizeUnit.PIXELS;
//            this.containment = Containment.DOCK_TOP;
//            this.flow = ContainerFlow.HORIZONTAL;

            var appLogo:Bitmap = new Resources.LOGO_IMG();
            var appLogoImage:Image = new Image();
            appLogoImage.setImage(appLogo);

//            var aboutIcon:Bitmap = new Resources.ABOUT_ICON();
            var aboutBtn:IconButton = new IconButton();
            aboutBtn.width = 50;
//            aboutBtn.setIcon(aboutIcon);
            aboutBtn.addEventListener(MouseEvent.CLICK, onAboutClick);

        }

        private function onAboutClick(event:MouseEvent):void
        {
            CONFIG::device
            {
                aboutDialog = new AlertDialog();
                aboutDialog.title = "Morse Code Generator - v." + versionNumber;
                aboutDialog.message = "Author: Jarek Szczepański\n" +
                                      "Email: support_bb@imrahil.com\n" +
                                      "Website:\nhttp://imrahil.github.com/";
                aboutDialog.addButton("OK");
                aboutDialog.addEventListener(Event.SELECT, aboutButtonClicked);
                aboutDialog.show();
            }
        }

        private function aboutButtonClicked(event:Event):void
        {
            aboutDialog.cancel();
        }
    }
}
