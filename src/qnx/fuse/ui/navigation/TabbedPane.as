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
    import caurina.transitions.Tweener;

    import flash.display.DisplayObjectContainer;

    import qnx.fuse.ui.core.Action;
    import qnx.fuse.ui.core.ActionBase;
    import qnx.fuse.ui.core.TabAction;
    import qnx.fuse.ui.events.DragEvent;
    import qnx.fuse.ui.events.NavigationEvent;

    /**
     * @author juliandolce
     */
    public class TabbedPane extends BasePane
    {
        private var __tabs:Vector.<Tab>;
        private var __actions:Vector.<Action>;
        private var __activeTab:Tab;
        private var __tabsChanged:Boolean;
        private var __activeTabChanged:Boolean;

        private var __activePane:BasePane;
        private var __tabOverFlowParent:DisplayObjectContainer;
        private var __slideX:Number = 0;

        public function get tabOverflowParent():DisplayObjectContainer
        {
            return( __tabOverFlowParent );
        }

        public function set tabOverflowParent(value:DisplayObjectContainer):void
        {
            if (__tabOverFlowParent != value)
            {
                __tabOverFlowParent = value;
                if (actionBar)
                {
                    actionBar.tabOverflowParent = value;
                }
            }
        }

        public function get activeTab():Tab
        {
            return( __activeTab );
        }

        public function set activeTab(value:Tab):void
        {
            if (__activeTab != value)
            {
                var index:int = __tabs.indexOf(value);
                if (index != -1)
                {
                    __activeTab = value;
                    __activeTabChanged = true;
                    invalidateProperties();
                }
            }
        }

        public function get tabs():Vector.<Tab>
        {
            return( __tabs );
        }

        public function set tabs(value:Vector.<Tab>):void
        {
            if (__tabs != value)
            {
                __tabs = value;
                __tabsChanged = true;
                invalidateProperties();
            }
        }

        public function TabbedPane()
        {
            super();
        }

        override protected function commitProperties():void
        {
            super.commitProperties();
            if (__tabsChanged)
            {
                updateActionBar();
                __tabsChanged = false;
            }

            if (__activeTabChanged)
            {
                var actionBarItems:uint = actionBar.totalItems;
                for (var i:int = 0; i < actionBarItems; i++)
                {
                    var action:TabAction = actionBar.getActionAt(i) as TabAction;
                    if (action)
                    {
                        if (Tab(action.data) == __activeTab)
                        {
                            actionBar.selectedTabAction = action;
                            break;
                        }
                    }
                }

                addTabbedPane();
                __activeTabChanged = false;
            }
        }

        override protected function createActionBar():void
        {
            if (__tabs != null && __tabs.length > 0)
            {
                super.createActionBar();
                if (actionBar)
                {
                    actionBar.tabOverflowParent = __tabOverFlowParent;
                    actionBar.addEventListener(DragEvent.DRAG_MOVE, onDragMove);
                }
            }
        }

        private function onDragMove(event:DragEvent):void
        {
            __slideX += event.deltaX;
            this.x = Math.round(__slideX + stage.stageWidth);
        }

        private function updateActionBar():void
        {
            if (__tabs != null)
            {
                createActionBar();

                if (actionBar)
                {
                    actionBar.removeAll();

                    for (var i:int = 0; i < __tabs.length; i++)
                    {
                        var tab:Tab = __tabs[ i ];
                        //TODO currently the Tab is the data object.
                        //We probably want to make TabAction the Tab class in the future.
                        //But TabAction is final.
                        actionBar.addAction(new TabAction(tab.label, tab.icon, tab));
                    }
                }
            }
        }

        private function addTabbedPane():void
        {
            var showBar:Boolean = false;
            if (actionBar)
            {
                showBar = actionBar.totalItems > 0;
            }

            setActionBarVisibility(showBar);

            var animate:Boolean = false;

            var oldPane:BasePane;
            if (__activePane != null)
            {
                if (__activePane is NavigationPane)
                {
                    __activePane.removeEventListener(NavigationEvent.POP, pagedPopped);
                }

                if (contains(__activePane))
                {
                    //TODO handle some sort of animation here
                    animate = true;
                    oldPane = __activePane;
                }
            }

            if (__activeTab)
            {
                __activePane = __activeTab.content;

                resizeActivePane();

                if (__activePane is NavigationPane)
                {
                    __activePane.addEventListener(NavigationEvent.POP, pagedPopped);
                }

                addChild(__activePane);
                if (animate)
                {
                    __activePane.alpha = 0;
                    Tweener.addTween(__activePane, {alpha: 1, time: 0.5, onComplete: inAnimationComplete, onCompleteParams: [oldPane]});
                }
                else
                {
                    inAnimationComplete(oldPane);
                }
            }

            removeAndUpdateActions();
        }

        private function inAnimationComplete(oldPane:BasePane):void
        {
            if (oldPane != null && contains(oldPane))
            {
                removeChild(oldPane);
            }

            __activePane.dispatchEvent(new NavigationEvent(NavigationEvent.TRANSITION_IN_COMPLETE));
        }

        private function removeAndUpdateActions():void
        {
            var i:int = 0;
            if (__actions && actionBar)
            {
                for (i = 0; i < __actions.length; i++)
                {
                    actionBar.removeAction(__actions[ i ]);
                }

                __actions = null;
            }

            __actions = getActionsToDisplayOnBar();

            if (__actions && actionBar)
            {
                for (i = 0; i < __actions.length; i++)
                {
                    actionBar.addAction(__actions[ i ]);
                }
            }
        }

        private function pagedPopped(event:NavigationEvent):void
        {
            var navPane:NavigationPane = event.target as NavigationPane;
            sizeNavigationPaneStack(navPane);
        }

        private function sizeNavigationPaneStack(pane:NavigationPane):void
        {
            if (pane.stack.length > 1)
            {
                pane.top.height = height;
                pane.top.width = width;
            }
            else if (pane.stack.length == 1)
            {
                pane.stack[ 0 ].height = getContentHeight();
                pane.stack[ 0 ].width = width;
            }
        }

        private function resizeActivePane():void
        {
            __activePane.width = width;

            if (__activePane is NavigationPane)
            {
                __activePane.height = height;
                sizeNavigationPaneStack(__activePane as NavigationPane);
            }
            else
            {
                __activePane.height = getContentHeight();
            }
        }


        override public function onActionSelected(action:ActionBase):void
        {
            if (action is TabAction)
            {
                activeTab = Tab(action.data);
            }
            else if (action is Action)
            {
                __activePane.onActionSelected(action);
            }
        }

        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);

            if (__activePane)
            {
                resizeActivePane();
            }
        }

        override public function getActionsToDisplayOnBar():Vector.<Action>
        {
            if (__activePane)
            {
                return(__activePane.getActionsToDisplayOnBar());
            }

            return(super.getActionsToDisplayOnBar());
        }
    }
}
