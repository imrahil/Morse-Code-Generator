/*
 * Copyright (c) 2013 Research In Motion Limited.
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
    import qnx.fuse.ui.listClasses.ScrollDirection;
    import qnx.fuse.ui.navigation.Page;
    import qnx.fuse.ui.titlebar.TitleBar;

    /**
     * @author juliandolce
     */
    public class TitlePage extends Page
    {
        private var _title:String;

        protected var container:Container;

        public function set title(value:String):void
        {
            if (_title != value)
            {
                _title = value;
                if (titleBar != null)
                {
                    titleBar.title = value;
                }
            }
        }

        public function get title():String
        {
            return _title;
        }

        override protected function onAdded():void
        {
            super.onAdded();

            container = new Container();
            container.scrollDirection = ScrollDirection.VERTICAL;

            var s:Sprite = new Sprite();
            var g:Graphics = s.graphics;
            g.beginFill(0x0c151c);
            g.drawRect(0, 0, 10, 10);
            g.endFill();

            container.background = s;

            titleBar = new TitleBar();

            if (_title != null)
            {
                titleBar.title = _title;
            }
        }
    }
}
