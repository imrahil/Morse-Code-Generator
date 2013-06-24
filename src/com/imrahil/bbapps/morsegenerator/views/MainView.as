/*
 Copyright (c) 2013 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
package com.imrahil.bbapps.morsegenerator.views
{
    import caurina.transitions.Tweener;

    import com.imrahil.bbapps.morsegenerator.constants.Resources;

    import flash.display.Graphics;

    import flash.display.Sprite;
    import flash.events.MouseEvent;

    import qnx.events.QNXApplicationEvent;

    import qnx.fuse.ui.Application;
    import qnx.fuse.ui.applicationMenu.ApplicationMenu;
    import qnx.fuse.ui.core.Action;
    import qnx.fuse.ui.events.ActionEvent;
    import qnx.fuse.ui.navigation.NavigationPane;

    import qnx.fuse.ui.navigation.Tab;
    import qnx.fuse.ui.navigation.TabbedPane;
    import qnx.fuse.ui.theme.ThemeGlobals;
    import qnx.system.QNXApplication;

    public class MainView extends Application
    {
        private var tabbedPane:TabbedPane;

        private var appMenu:ApplicationMenu;
        private var blackLayer:Sprite;

        override protected function onAdded():void
        {
            super.onAdded();

            ThemeGlobals.currentTheme = ThemeGlobals.BLACK;

            tabbedPane = new TabbedPane();

            var tabs:Vector.<Tab> = new Vector.<Tab>();

            tabs.push(createNavPane("Encode/Decode", new Resources.ICON_ENCODE(), EncodeView));
            tabs.push(createNavPane("Share", new Resources.ICON_SHARE(), ShareView));

//            tabs.push(createNavPane("About", new Resources.ICON_ABOUT(), AboutView));
//            tabs.push(createTab("Help", new Resources.ICON_HELP(), HelpView));
//            tabs.push(createTab("Settings", new Resources.ICON_SETTINGS(), SettingsView));

            tabbedPane.tabs = tabs;
            tabbedPane.activeTab = tabs[0];

            scene = tabbedPane;

            appMenu = new ApplicationMenu();
            appMenu.width = stage.stageWidth;
            appMenu.helpAction = new Action("Help", new Resources.ICON_HELP(), 1);
            appMenu.settingsAction = new Action("Settings", new Resources.ICON_SETTINGS(), 2);
            appMenu.addEventListener(ActionEvent.ACTION_SELECTED, actionSelected);

            blackLayer = new Sprite();
            var g:Graphics = blackLayer.graphics;
            g.beginFill(0x000000);
            g.drawRect(0, 0, 10, 10);
            g.endFill();
            blackLayer.addEventListener(MouseEvent.CLICK, removeTopMenu);

            QNXApplication.qnxApplication.addEventListener(QNXApplicationEvent.SWIPE_DOWN, onApplicationSwipeDown);
        }

        private function removeTopMenu(event:MouseEvent):void
        {
            animateMenu();
        }

        private function onApplicationSwipeDown(event:QNXApplicationEvent):void
        {
            animateMenu();
        }

        private function actionSelected(e:ActionEvent):void
        {
            animateMenu();

            switch (e.action.data)
            {
                case 1: //help
                    var helpView:HelpView = new HelpView();
                    (tabbedPane.activeTab.content as NavigationPane).push(helpView);
                    break;
                case 2: //settings
                    var settingsView:SettingsView = new SettingsView();
                    (tabbedPane.activeTab.content as NavigationPane).push(settingsView);
                    break;
            }
        }

        private function animateMenu():void
        {
            var to:int = 0;

            if (this.contains(appMenu))
            {
                to = -appMenu.height;
            }
            else
            {
                blackLayer.width = stage.stageWidth;
                blackLayer.height = stage.stageHeight;
                this.addChild(blackLayer);

                appMenu.y = -appMenu.height;
                this.addChild(appMenu);

                to = 0;
            }

            Tweener.addTween(appMenu, {y: to, time: 0.2, transition: "linear", onComplete: function ():void
            {
                if (appMenu.y < 0)
                {
                    removeChild(appMenu);
                    removeChild(blackLayer);
                }
            }, onUpdate: function ():void
            {
                tabbedPane.y = appMenu.y + appMenu.height;
                blackLayer.alpha = (1 - Math.abs(appMenu.y / appMenu.height)) * 0.5;
            }});
        }

        public static function createNavPane(label:String, icon:Object, content:Class):Tab
        {
            var navPane:NavigationPane = new NavigationPane();
            navPane.push(new content());
            var navTab:Tab = new Tab(label, icon);
            navTab.content = navPane;

            return navTab;
        }
    }
}
