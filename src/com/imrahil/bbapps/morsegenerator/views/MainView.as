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

    import qnx.fuse.ui.Application;

    import qnx.fuse.ui.navigation.Tab;
    import qnx.fuse.ui.navigation.TabbedPane;
    import qnx.fuse.ui.theme.ThemeGlobals;

    public class MainView extends Application
    {
        private var tabbedPane:TabbedPane;

        override protected function onAdded():void
        {
            super.onAdded();

            ThemeGlobals.currentTheme = ThemeGlobals.BLACK;

            tabbedPane = new TabbedPane();

            var tabs:Vector.<Tab> = new Vector.<Tab>();

            tabs.push(createTab("Encode/Decode", new Resources.ICON_ENCODE(), EncodeView));
            tabs.push(createTab("Share", new Resources.ICON_SHARE(), ShareView));
            tabs.push(createTab("Help", new Resources.ICON_HELP(), HelpView));

            tabs.push(createTab("Settings", new Resources.ICON_SETTINGS(), SettingsView));
            tabs.push(createTab("About", new Resources.ICON_ABOUT(), AboutView));

            tabbedPane.tabs = tabs;
            tabbedPane.activeTab = tabs[0];

            scene = tabbedPane;
        }

        private static function createTab(label:String, icon:Object, content:Class):Tab
        {
            var tab:Tab = new Tab(label, icon);
            tab.content = new content();

            return tab;
        }
    }
}
