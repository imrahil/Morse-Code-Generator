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

    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;

    import qnx.fuse.ui.navigation.NavigationPane;
    import qnx.fuse.ui.navigation.Tab;
    import qnx.fuse.ui.navigation.TabbedPane;

    public class MainView extends Sprite
    {
        private var tabbedPane:TabbedPane;
        private var tabOverFlow:Sprite;

        public function MainView()
        {
            this.addEventListener(Event.ADDED_TO_STAGE, create)
        }

        private function create(event:Event):void
        {
            this.removeEventListener(Event.ADDED_TO_STAGE, create);

            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.addEventListener(Event.RESIZE, stageResize);

            tabOverFlow = new Sprite();
            addChild(tabOverFlow);

            tabbedPane = new TabbedPane();
            tabbedPane.tabOverflowParent = tabOverFlow;

            var tabs:Vector.<Tab> = new Vector.<Tab>();

            /***************
             *    HOME
             ***************/
            var encodeView:EncodeView = new EncodeView();

            var homeTab:Tab = new Tab("Encode/Decode", new Resources.ICON_ENCODE());
            homeTab.content = encodeView;
            tabs.push(homeTab);

            tabs.push(createTab("Share", new Resources.ICON_SHARE(), ShareView));

            /***************
             *  SETTINGS
             ***************/
            var settingsView:NavigationPane = new NavigationPane();
            settingsView.push(new SettingsView());
            var settingsTab:Tab = new Tab("Settings", new Resources.ICON_SETTINGS());
            settingsTab.content = settingsView;
            tabs.push(settingsTab);

            tabs.push(createTab("Help", new Resources.ICON_HELP(), HelpView));
            tabs.push(createTab("About", new Resources.ICON_ABOUT(), AboutView));

            // TEXT FORMAT
//            var textFormat:TextFormat = new TextFormat();
//            textFormat.color = 0xFFFFFF;
//
//            // BASE
//            var base:Container = new Container();
//            base.flow = ContainerFlow.VERTICAL;
//
//            // CONTENT
//            var content:Container = new Container();
//            content.margins = Vector.<Number>([15, 0, 15, 15]);
//            content.flow = ContainerFlow.HORIZONTAL;
//
//            // HEADER
//            var header:HeaderView = new HeaderView(textFormat);
//
//            // LEFT
//            var leftContainer:LeftContainer = new LeftContainer(textFormat);
//
//            // RIGHT
//            var rightContainer:RightContainer = new RightContainer(textFormat);
//
//            // FOOTER
//            var footer:FooterView = new FooterView(textFormat);
//
//            content.addChild(leftContainer);
//            content.addChild(rightContainer);
//
//            base.addChild(header);
//            base.addChild(content);
//            base.addChild(footer);

            tabbedPane.tabs = tabs;
            tabbedPane.activeTab = tabs[0];

            this.addChild(tabbedPane);
        }

        private function createTab(label:String, icon:Object, content:Class):Tab
        {
            var tab:Tab = new Tab(label, icon);
            tab.content = new content();
            return( tab );
        }

        private function stageResize(event:Event):void
        {
            tabbedPane.width = stage.stageWidth;
            tabbedPane.height = stage.stageHeight;
        }
    }
}
