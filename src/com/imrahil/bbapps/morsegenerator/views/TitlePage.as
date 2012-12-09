/*
 * Copyright (c) 2012 Research In Motion Limited.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.imrahil.bbapps.morsegenerator.views
{
    import flash.display.Graphics;
    import flash.display.Sprite;

    import qnx.fuse.ui.core.Container;
    import qnx.fuse.ui.core.SizeOptions;
    import qnx.fuse.ui.layouts.Align;
    import qnx.fuse.ui.layouts.gridLayout.GridData;
    import qnx.fuse.ui.layouts.gridLayout.GridLayout;
    import qnx.fuse.ui.navigation.Page;
    import qnx.fuse.ui.titlebar.TitleBar;

    /**
     * @author juliandolce
     */
    public class TitlePage extends Page
    {
        private var __title:String;

        public function set title(value:String):void
        {
            if (__title != value)
            {
                __title = value;
                if (titleBar != null)
                {
                    titleBar.title = value;
                }
            }
        }

        public function get title():String
        {
            return(__title);
        }

        public function TitlePage()
        {
            super();
        }

        override protected function init():void
        {
            super.init();
        }

        override protected function onAdded():void
        {
            super.onAdded();
            var container:Container = new Container();

            var s:Sprite = new Sprite();
            var g:Graphics = s.graphics;
            g.beginFill(0xf8f8f8);
            g.drawRect(0, 0, 10, 10);
            g.endFill();

            container.background = s;

            var layout:GridLayout = new GridLayout(1);
            container.layout = layout;

            var containerData:GridData = new GridData();
            containerData.hAlign = Align.BEGIN;
            containerData.vAlign = Align.BEGIN;
            containerData.setOptions(SizeOptions.RESIZE_BOTH);
            container.layoutData = containerData;

            titleBar = new TitleBar();

            content = container;

            if (__title != null)
            {
                titleBar.title = __title;
            }
        }
    }
}
