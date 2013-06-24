/*
 Copyright (c) 2013 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
package com.imrahil.bbapps.morsegenerator.views
{
    import com.imrahil.bbapps.morsegenerator.constants.Resources;
    import com.imrahil.bbapps.morsegenerator.utils.TextFormatUtil;

    import flash.events.MouseEvent;

    import org.osflash.signals.Signal;

    import qnx.fuse.ui.actionbar.ActionPlacement;
    import qnx.fuse.ui.buttons.LabelButton;
    import qnx.fuse.ui.core.Action;
    import qnx.fuse.ui.core.ActionBase;
    import qnx.fuse.ui.core.Container;
    import qnx.fuse.ui.core.SizeOptions;
    import qnx.fuse.ui.display.Image;
    import qnx.fuse.ui.layouts.Align;
    import qnx.fuse.ui.layouts.gridLayout.GridData;
    import qnx.fuse.ui.layouts.gridLayout.GridLayout;
    import qnx.fuse.ui.navigation.NavigationPaneProperties;
    import qnx.fuse.ui.text.Label;

    public class HelpView extends TitlePage
    {
        private var aboutAction:Action;

        public var longBeepClickSignal:Signal = new Signal();
        public var shortBeepClickSignal:Signal = new Signal();

        public var longBeepBtn:LabelButton;
        public var shortBeepBtn:LabelButton;

        public function HelpView()
        {
            super();

            title = "Help";
        }

        override protected function init():void
        {
            super.init();

            var prop:NavigationPaneProperties = new NavigationPaneProperties();
            prop.backButton = new Action("Back");
            paneProperties = prop;

            aboutAction = new Action("About", new Resources.ICON_ABOUT());
            aboutAction.actionBarPlacement = ActionPlacement.ON_BAR;

            actions = new Vector.<ActionBase>();
            actions.push(aboutAction);
        }

        override protected function onAdded():void
        {
            super.onAdded();

            var layout:GridLayout = new GridLayout();
            layout.paddingLeft = 30;
            layout.paddingRight = 30;
            layout.paddingTop = 30;
            layout.paddingBottom = 60;
            container.layout = layout;

            var infoLabel:Label = new Label();
            infoLabel.text = "International Morse Code:";
            infoLabel.format = TextFormatUtil.setFormat(infoLabel.format);

            container.addChild(infoLabel);

            var morseTableImage:Image = new Image();
            morseTableImage.setImage(new Resources.MORSE_TABLE());
            morseTableImage.fixedAspectRatio = true;

            var morseTableData:GridData = new GridData();
            morseTableData.setOptions(SizeOptions.NONE);
            morseTableData.hAlign = Align.BEGIN;
            morseTableData.marginTop = 20;
            morseTableData.marginBottom = 20;
            morseTableImage.layoutData = morseTableData;

            container.addChild(morseTableImage);

            infoLabel = new Label();
            infoLabel.text = "Training Mode:";
            infoLabel.format = TextFormatUtil.setFormat(infoLabel.format);

            container.addChild(infoLabel);


            var trainingBtnContainer:Container = new Container();
            layout = new GridLayout();
            layout.numColumns = 2;
            layout.hSpacing = 40;
            layout.paddingTop = 30;
            layout.paddingBottom = 20;
            trainingBtnContainer.layout = layout;

            var containerData:GridData = new GridData();
            containerData.hAlign = Align.FILL;
            containerData.vAlign = Align.FILL;
            containerData.preferredHeight = 300;
            containerData.setOptions(SizeOptions.RESIZE_HORIZONTAL);
            trainingBtnContainer.layoutData = containerData;

            longBeepBtn = new LabelButton();
            longBeepBtn.label = "Long Beep";
            longBeepBtn.addEventListener(MouseEvent.CLICK, onLongBeepClick);
            longBeepBtn.layoutData = containerData;
            trainingBtnContainer.addChild(longBeepBtn);

            shortBeepBtn = new LabelButton();
            shortBeepBtn.label = "Short Beep";
            shortBeepBtn.addEventListener(MouseEvent.CLICK, onShortBeepClick);
            shortBeepBtn.layoutData = containerData;
            trainingBtnContainer.addChild(shortBeepBtn);

            container.addChild(trainingBtnContainer);

            content = container;
        }

        private function onLongBeepClick(event:MouseEvent):void
        {
            longBeepClickSignal.dispatch();
        }

        private function onShortBeepClick(event:MouseEvent):void
        {
            shortBeepClickSignal.dispatch();
        }

        override public function onActionSelected(action:ActionBase):void
        {
            if (action == aboutAction)
            {
                var aboutPage:AboutView = new AboutView();
                pushPage(aboutPage);
            }
            else
            {
                super.onActionSelected(action);
            }
        }
    }
}
