package com.imrahil.bbapps.morsegenerator.views
{
    import com.imrahil.bbapps.morsegenerator.constants.ApplicationConstants;
    import com.imrahil.bbapps.morsegenerator.constants.Resources;

    import flash.desktop.Clipboard;
    import flash.desktop.ClipboardFormats;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Graphics;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;

    import org.osflash.signals.Signal;

    import qnx.dialog.AlertDialog;
    import qnx.dialog.DialogSize;
    import qnx.display.IowWindow;

    import qnx.ui.buttons.IconButton;
    import qnx.ui.buttons.LabelButton;
    import qnx.ui.core.Container;
    import qnx.ui.core.ContainerAlign;
    import qnx.ui.core.ContainerFlow;
    import qnx.ui.core.SizeUnit;
    import qnx.ui.core.Spacer;
    import qnx.ui.display.Image;
    import qnx.ui.text.Label;

    public class RightContainer extends StyledContainer
	{
        public var playBtnClickSignal:Signal = new Signal();
        public var flickerBtnClickSignal:Signal = new Signal();

        public var clipboardBtnClickSignal:Signal = new Signal();

        public var playBtn:LabelButton;
        public var flickerBtn:LabelButton;

        public var copyLabel:Label;

        public var clipboardBtn:IconButton;
        public var facebookBtn:IconButton;

        public var clipboardIcon:Bitmap;
        public var clipboardIconDisabled:Bitmap;
        public var facebookIcon:Bitmap;
        public var facebookIconDisabled:Bitmap;

        public var mySpectrumGraph:BitmapData;
        public var outputLabel:Label;

        private var facebookDialog:AlertDialog;

		public function RightContainer(textFormat:TextFormat)
		{
			super(textFormat);

            this.addEventListener(Event.ADDED_TO_STAGE, create)
		}

		private function create(event:Event):void
		{
            this.removeEventListener(Event.ADDED_TO_STAGE, create);

			this.margins = Vector.<Number>([30, 0, 10, 10]);
			this.size = 50;
			this.sizeUnit = SizeUnit.PERCENT;
			this.padding = 0;
			this.align = ContainerAlign.NEAR;
			
			var titleLabel:Label = new Label();
			titleLabel.text = "Output:";
			titleLabel.autoSize = TextFieldAutoSize.CENTER;
			titleLabel.format = textFormat;
			
			var morseTextFormat:TextFormat = new TextFormat();
			morseTextFormat.color = textFormat.color;
			morseTextFormat.size = 20;
			morseTextFormat.bold = true;
			
            outputLabel = new Label();
			outputLabel.multiline = true;
			outputLabel.wordWrap = true;
			outputLabel.format = morseTextFormat;
			outputLabel.setSize(442, 125);
			
			var g:Graphics = outputLabel.graphics;
			g.lineStyle(1, 0x666666);
			g.moveTo(0, 0);
			g.lineTo(440, 0);
			g.lineTo(440, 125);
			g.lineTo(0, 125);
			g.lineTo(0, 0);
			
			var buttonContainer:Container = new Container();
			buttonContainer.size = 50;
			buttonContainer.sizeUnit = SizeUnit.PIXELS;
			buttonContainer.align = ContainerAlign.MID;
			buttonContainer.flow = ContainerFlow.HORIZONTAL;
			buttonContainer.padding = 0;
			
            playBtn = new LabelButton();
			playBtn.label = "PLAY";
			playBtn.enabled = false;
			playBtn.width = 100;
            playBtn.addEventListener(MouseEvent.CLICK, onPlayBtnClick);
			buttonContainer.addChild(playBtn);

            flickerBtn = new LabelButton();
			flickerBtn.label = "FLICKER";
			flickerBtn.enabled = false;
			flickerBtn.width = 100;
            flickerBtn.addEventListener(MouseEvent.CLICK, onFlickerBtnClick);
			buttonContainer.addChild(flickerBtn);

            buttonContainer.addChild(new Spacer(79, SizeUnit.PIXELS));

            copyLabel = new Label();
            copyLabel.text = "";
            copyLabel.width = 55;
            copyLabel.format = textFormat;
            buttonContainer.addChild(copyLabel);

            clipboardIconDisabled = new Resources.CLIPBOARD_ICON_DISABLED();
            clipboardBtn = new IconButton();
            clipboardBtn.enabled = false;
            clipboardBtn.width = 50;
            clipboardBtn.setIcon(clipboardIconDisabled);
            clipboardBtn.addEventListener(MouseEvent.CLICK, onClipboardBtnClick);
            buttonContainer.addChild(clipboardBtn);

            buttonContainer.addChild(new Spacer(10, SizeUnit.PIXELS));

            facebookIconDisabled = new Resources.FACEBOOK_ICON_DISABLED();
            facebookBtn = new IconButton();
            facebookBtn.enabled = false;
            facebookBtn.width = 50;
            facebookBtn.setIcon(facebookIconDisabled);
            facebookBtn.addEventListener(MouseEvent.CLICK, onFacebookBtnClick);
            buttonContainer.addChild(facebookBtn);

			this.addChild(titleLabel);
			this.addChild(outputLabel);
            this.addChild(new Spacer(5, SizeUnit.PIXELS))
			this.addChild(buttonContainer);

			this.addChild(new Spacer(10, SizeUnit.PIXELS));

			var graphContainer:Container = new Container();
			graphContainer.size = 50;
			graphContainer.sizeUnit = SizeUnit.PIXELS;
			graphContainer.align = ContainerAlign.MID;
			graphContainer.flow = ContainerFlow.HORIZONTAL;
			graphContainer.padding = 0;
			
			graphContainer.addChild(new Spacer(92, SizeUnit.PIXELS));
			
            mySpectrumGraph = new BitmapData(300, 45, true, 0x00000000);
			var bitmap:Bitmap = new Bitmap(mySpectrumGraph);
			var spectrumImage:Image = new Image();
			spectrumImage.setImage(bitmap);
			graphContainer.addChild(spectrumImage);
			
			this.addChild(graphContainer);
		}

        private function onPlayBtnClick(event:MouseEvent):void
        {
            playBtnClickSignal.dispatch();
        }

        private function onFlickerBtnClick(event:MouseEvent):void
        {
            flickerBtnClickSignal.dispatch();
        }

        private function onClipboardBtnClick(event:MouseEvent):void
        {
            clipboardBtnClickSignal.dispatch();
        }

        private function onFacebookBtnClick(event:MouseEvent):void
        {
            facebookDialog = new AlertDialog();
            facebookDialog.title = "Post message on your Facebook wall!";
            facebookDialog.message = "Your message is in your clipboard. Click POST button to open Facebook and paste there your message in Morse code.";
            facebookDialog.addButton("POST");
            facebookDialog.addButton("CANCEL");
            facebookDialog.dialogSize = DialogSize.SIZE_SMALL;
            facebookDialog.addEventListener(Event.SELECT, facebookAlertButtonClickHandler);
            facebookDialog.show(IowWindow.getAirWindow().group);
        }

        private function facebookAlertButtonClickHandler(event:Event):void
        {
            if (event.target.selectedIndex == 0)
            {
                Clipboard.generalClipboard.clear();
                Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, outputLabel.text);

                navigateToURL(new URLRequest(ApplicationConstants.FACEBOOK_URL));
            }

            facebookDialog.cancel();
        }
	}
}
