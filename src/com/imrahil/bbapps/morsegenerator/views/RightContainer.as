package com.imrahil.bbapps.morsegenerator.views
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
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
		private var outputLabel:Label;
		public var playBtn:LabelButton;
		public var flickerBtn:LabelButton;
		public var mySpectrumGraph:BitmapData;
		
		public function RightContainer(textFormat:TextFormat)
		{
			super(textFormat);
			
			create();
		}
		
		private function create():void
		{
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
			
			buttonContainer.addChild(new Spacer(120, SizeUnit.PIXELS));
			
			playBtn = new LabelButton();
			playBtn.label = "PLAY";
			playBtn.enabled = false;
			playBtn.width = 100;
			buttonContainer.addChild(playBtn);

			flickerBtn = new LabelButton();
			flickerBtn.label = "FLICKER";
			flickerBtn.enabled = false;
			flickerBtn.width = 100;
			buttonContainer.addChild(flickerBtn);

			this.addChild(titleLabel);
			this.addChild(outputLabel);
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
		
		public function changeOutput(value:String = ""):void
		{
			outputLabel.text = value;
		}
	}
}
