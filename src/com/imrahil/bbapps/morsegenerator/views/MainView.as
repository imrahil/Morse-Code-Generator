/*
 Copyright (c) 2012 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
package com.imrahil.bbapps.morsegenerator.views
{
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.text.TextFormat;

    import qnx.ui.core.Container;
    import qnx.ui.core.ContainerFlow;

    public class MainView extends Sprite
    {
        public function MainView()
        {
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
            var leftContainer:LeftContainer = new LeftContainer(textFormat);

            // RIGHT
            var rightContainer:RightContainer = new RightContainer(textFormat);

            // FOOTER
            var footer:FooterView = new FooterView(textFormat);

            content.addChild(leftContainer);
            content.addChild(rightContainer);

            base.addChild(header);
            base.addChild(content);
            base.addChild(footer);

            this.addChild(base);

            base.setSize(stage.stageWidth, stage.stageHeight);
        }
    }
}
