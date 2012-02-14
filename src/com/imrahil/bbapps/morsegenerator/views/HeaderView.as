package com.imrahil.bbapps.morsegenerator.views
{
    import com.imrahil.bbapps.morsegenerator.constants.Resources;

    import flash.desktop.NativeApplication;
    import flash.display.Bitmap;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.TextFormat;

    import qnx.dialog.AlertDialog;
    import qnx.dialog.DialogSize;
    import qnx.display.IowWindow;
    import qnx.ui.buttons.IconButton;
    import qnx.ui.core.ContainerFlow;
    import qnx.ui.core.Containment;
    import qnx.ui.core.SizeUnit;
    import qnx.ui.core.Spacer;
    import qnx.ui.display.Image;

    public class HeaderView extends StyledContainer
	{
		private var aboutDialog:AlertDialog;
		private var versionNumber:String;

		public function HeaderView(format:TextFormat)
		{
			super(format);
			
            this.addEventListener(Event.ADDED_TO_STAGE, create)
		}

		private function create(event:Event):void
		{
            this.removeEventListener(Event.ADDED_TO_STAGE, create);

			var app_xml:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = app_xml.namespace();
			versionNumber = app_xml.ns::versionNumber;

			this.margins = Vector.<Number>([0, 0, 10, 10]);
			this.size = 70;
			this.sizeUnit = SizeUnit.PIXELS;
			this.containment = Containment.DOCK_TOP;
			this.flow = ContainerFlow.HORIZONTAL;
			
			var appLogo:Bitmap = new Resources.LOGO_IMG();
			var appLogoImage:Image = new Image();
			appLogoImage.setImage(appLogo);
			
			var settingsIcon:Bitmap = new Resources.SETTINGS_ICON();
			var settingsBtn:IconButton = new IconButton();
			settingsBtn.width = 50;
			settingsBtn.setIcon(settingsIcon);
            settingsBtn.addEventListener(MouseEvent.CLICK, onSettingsClick);

			var aboutIcon:Bitmap = new Resources.ABOUT_ICON();
			var aboutBtn:IconButton = new IconButton();
			aboutBtn.width = 50;
			aboutBtn.setIcon(aboutIcon);
			aboutBtn.addEventListener(MouseEvent.CLICK, onAboutClick);
			
			this.addChild(appLogoImage);
            this.addChild(new Spacer(265, SizeUnit.PIXELS));
            this.addChild(settingsBtn);
            this.addChild(aboutBtn);

            // HEADER LINE
			this.graphics.beginFill(0x1C3041);
			this.graphics.drawRect(-15, 60, 1024, 5);
			this.graphics.endFill();
		}

		private function onAboutClick(event:MouseEvent):void
		{
			aboutDialog = new AlertDialog();
			aboutDialog.title = "Morse Code Generator - v." + versionNumber;
			aboutDialog.messageHtml = "<p align='center'><b>Author:</b> Jarek Szczepański<br />" +
                                      "<b>Email:</b> support_bb@imrahil.com<br />" +
                                      "<b>Website:</b> http://flex.imrahil.com</p>";
			aboutDialog.addButton("OK");
			aboutDialog.dialogSize = DialogSize.SIZE_SMALL;
			aboutDialog.addEventListener(Event.SELECT, aboutButtonClicked); 
			aboutDialog.show(IowWindow.getAirWindow().group);
		}
		
		private function aboutButtonClicked(event:Event):void
		{
			aboutDialog.cancel();
		}


        private function onSettingsClick(event:MouseEvent):void
        {

        }
	}
}
