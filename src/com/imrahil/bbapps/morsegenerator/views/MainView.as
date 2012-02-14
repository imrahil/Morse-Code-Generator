package com.imrahil.bbapps.morsegenerator.views
{
    import com.imrahil.bbapps.morsegenerator.services.IMorseCode;
    import com.imrahil.bbapps.morsegenerator.services.MorseCode;

    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.text.TextFormat;

    import qnx.ui.core.Container;
    import qnx.ui.core.ContainerFlow;

    public class MainView extends Sprite
    {
        public var leftContainer:LeftContainer;
        public var rightContainer:RightContainer;
        public var footer:FooterView;

        public var morseAlphabet:IMorseCode;

        public function MainView()
        {
            morseAlphabet = new MorseCode();

            this.addEventListener(Event.ADDED_TO_STAGE, create)
        }

        private function create(event:Event):void
        {
            this.removeEventListener(Event.ADDED_TO_STAGE, create);

            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;

            // TEXT FORMAT
            var textFormat:TextFormat = new TextFormat();
            textFormat.color = 0xFFFFFF;

            // BASE
            var base:Container = new Container();
            base.flow = ContainerFlow.VERTICAL;

            // CONTENT
            var content:Container = new Container();
            content.margins = Vector.<Number>([15, 0, 15, 15]);
            content.flow = ContainerFlow.HORIZONTAL;

            // HEADER
            var header:HeaderView = new HeaderView(textFormat);

            // LEFT
            leftContainer = new LeftContainer(textFormat);

            // TODO - move to mediator
//            left.inputText.addEventListener(Event.CHANGE, onInputChange);
//            left.speedSlider.addEventListener(SliderEvent.MOVE, speedSlider_moveHandler);

            // RIGHT
            rightContainer = new RightContainer(textFormat);

            // FOOTER
            footer = new FooterView(textFormat);

            content.addChild(leftContainer);
            content.addChild(rightContainer);

            base.addChild(header);
            base.addChild(content);
            base.addChild(footer);

            this.addChild(base);

            // TODO - move to mediator
//            right.playBtn.addEventListener(MouseEvent.CLICK, onPlayBtnClick);
//            right.flickerBtn.addEventListener(MouseEvent.CLICK, onFlickerBtnClick);
//
//            left.translateBtn.addEventListener(MouseEvent.CLICK, onTranslateClick);
//            left.setVolume(AudioManager.audioManager.getOutputLevel(AudioOutput.SPEAKERS));

            base.setSize(stage.stageWidth, stage.stageHeight);
        }
    }
}
