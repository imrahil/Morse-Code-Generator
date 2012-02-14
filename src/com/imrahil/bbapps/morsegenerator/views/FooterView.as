package com.imrahil.bbapps.morsegenerator.views
{
    import com.imrahil.bbapps.morsegenerator.constants.Resources;

    import flash.display.Bitmap;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;

    import org.osflash.signals.Signal;

    import qnx.ui.buttons.LabelButton;
    import qnx.ui.core.Container;
    import qnx.ui.core.ContainerAlign;
    import qnx.ui.core.ContainerFlow;
    import qnx.ui.core.SizeUnit;
    import qnx.ui.core.Spacer;
    import qnx.ui.display.Image;
    import qnx.ui.text.Label;

    public class FooterView extends StyledContainer
	{
        public var longBeepClickSignal:Signal = new Signal();
        public var shortBeepClickSignal:Signal = new Signal();

		public function FooterView(format:TextFormat)
		{
			super(format);

            this.addEventListener(Event.ADDED_TO_STAGE, create)
		}
		
		private function create(event:Event):void
		{
            this.removeEventListener(Event.ADDED_TO_STAGE, create);

			this.size = 215;
			this.sizeUnit = SizeUnit.PIXELS;
			this.margins = Vector.<Number>([25, 0, 25, 0]);
			this.flow = ContainerFlow.HORIZONTAL;
			
			var tableContainer:Container = new Container();
			tableContainer.size = 700;
			tableContainer.sizeUnit = SizeUnit.PIXELS;
			tableContainer.flow = ContainerFlow.VERTICAL;
			tableContainer.align = ContainerAlign.NEAR;
			
			var morseTableLbl:Label = new Label();
			morseTableLbl.text = "International Morse Code:";
			morseTableLbl.autoSize = TextFieldAutoSize.RIGHT;
			morseTableLbl.format = textFormat;
			
			var morseTable:Bitmap = new Resources.MORSE_TABLE();
			var morseTableImage:Image = new Image();
			morseTableImage.setImage(morseTable);
			
			tableContainer.addChild(morseTableLbl);
			tableContainer.addChild(new Spacer(10, SizeUnit.PIXELS));
			tableContainer.addChild(morseTableImage);
			
			var trainContainer:Container = new Container();
			trainContainer.flow = ContainerFlow.VERTICAL;
			trainContainer.align = ContainerAlign.MID;

			var trainLbl:Label = new Label();
			trainLbl.text = "Training Mode";
			trainLbl.width = 140;
			trainLbl.autoSize = TextFieldAutoSize.CENTER;
			trainLbl.format = textFormat;
			
			var trainButtonsContainer:Container = new Container();
			trainButtonsContainer.flow = ContainerFlow.HORIZONTAL;
			trainButtonsContainer.margins = Vector.<Number>([10, 0, 0, 0]); 
			
            var longBeepBtn:LabelButton = new LabelButton();
			longBeepBtn.label = "Long Beep";
			longBeepBtn.width = 120;
			longBeepBtn.height = 120;
            longBeepBtn.addEventListener(MouseEvent.CLICK, onLongBeepClick);
			trainButtonsContainer.addChild(longBeepBtn);

			trainButtonsContainer.addChild(new Spacer(10, SizeUnit.PIXELS));
			
            var shortBeepBtn:LabelButton = new LabelButton();
			shortBeepBtn.label = "Short Beep";
			shortBeepBtn.width = 120;
			shortBeepBtn.height = 120;
            shortBeepBtn.addEventListener(MouseEvent.CLICK, onShortBeepClick);
			trainButtonsContainer.addChild(shortBeepBtn);

			trainContainer.addChild(trainLbl);
			trainContainer.addChild(trainButtonsContainer);
			
			this.addChild(tableContainer);
			this.addChild(trainContainer);
		}

        private function onLongBeepClick(event:MouseEvent):void
        {
            longBeepClickSignal.dispatch();
        }

        private function onShortBeepClick(event:MouseEvent):void
        {
            shortBeepClickSignal.dispatch();
        }
	}
}
