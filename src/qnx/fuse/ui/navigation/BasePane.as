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
package qnx.fuse.ui.navigation
{
    import qnx.fuse.ui.actionbar.ActionBar;
    import qnx.fuse.ui.core.Action;
    import qnx.fuse.ui.core.ActionBase;
    import qnx.fuse.ui.core.UIComponent;
    import qnx.fuse.ui.events.ActionEvent;
    import qnx.fuse.ui.events.NavigationEvent;

    /**
     * @author juliandolce
     */
    public class BasePane extends UIComponent
    {
        private var __paneProperties:PaneProperties;

        protected var actionBar:ActionBar;

        public function get paneProperties():PaneProperties
        {
            return( __paneProperties );
        }

        public function set paneProperties(value:PaneProperties):void
        {
            if (__paneProperties != value)
            {
                __paneProperties = value;
                invalidateProperties();
                invalidateDisplayList();
            }
        }

        public function BasePane()
        {
        }

        override protected function init():void
        {
            super.init();

            addEventListener(NavigationEvent.TRANSITION_IN_COMPLETE, transitionInComplete);
            addEventListener(NavigationEvent.TRANSITION_OUT_COMPLETE, transitionOutComplete);
        }

        private function transitionInComplete(event:NavigationEvent):void
        {
            onTransitionInComplete();
        }

        protected function onTransitionInComplete():void
        {

        }

        private function transitionOutComplete(event:NavigationEvent):void
        {
            onTransitionOutComplete();
        }

        protected function onTransitionOutComplete():void
        {

        }

        private function actionSelected(event:ActionEvent):void
        {
            onActionSelected(event.action);
        }

        public function onActionSelected(action:ActionBase):void
        {

        }

        protected function createActionBar():void
        {
            //Do some checks here to figure out if we need one or not.

            actionBar = new ActionBar();
            actionBar.addEventListener(ActionEvent.ACTION_SELECTED, actionSelected);
        }

        protected function setActionBarVisibility(value:Boolean):void
        {
            if (actionBar)
            {
                if (value)
                {
                    addChild(actionBar);
                }
                else
                {
                    if (contains(actionBar))
                    {
                        removeChild(actionBar);
                    }
                }
            }
        }

        protected function getContentHeight():Number
        {
            if (actionBar && contains(actionBar))
            {
                return(actionBar.y);
            }

            return( height );
        }

        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);

            if (actionBar)
            {
                actionBar.width = unscaledWidth;
                actionBar.y = unscaledHeight - actionBar.height;
            }
        }

        protected function popPage():void
        {
            var navPane:NavigationPane = getNavPane();
            if (navPane)
            {
                navPane.pop();
            }
        }

        protected function popAndDeletePage():void
        {
            var navPane:NavigationPane = getNavPane();
            if (navPane)
            {
                navPane.popAndDelete();
            }
        }

        protected function pushPage(pane:Page):void
        {
            var navPane:NavigationPane = getNavPane();
            if (navPane)
            {
                navPane.push(pane);
            }
        }

        private function getNavPane():NavigationPane
        {
            if (parent != null)
            {
                var navPane:NavigationPane = parent as NavigationPane;

                return(navPane);
            }

            return(null);
        }

        public function getActionsToDisplayOnBar():Vector.<Action>
        {
            return(new Vector.<Action>());
        }
    }
}
