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

    import qnx.fuse.ui.core.Action;
    import qnx.fuse.ui.core.ActionBase;
    import qnx.fuse.ui.core.UIComponent;
    import qnx.fuse.ui.events.DragEvent;
    import qnx.fuse.ui.titlebar.TitleBar;

    /**
     * @author juliandolce
     */
    public class Page extends BasePane
    {
        private var __actions:Vector.<Action>;
        private var __content:UIComponent;
        private var __titleBar:TitleBar;
        private var __slideX:Number = 0;
        private var __backButtonDragging:Boolean;

        public function get actions():Vector.<Action>
        {
            return( __actions );
        }

        public function set actions(value:Vector.<Action>):void
        {
            if (__actions != value)
            {
                __actions = value;
            }
        }

        public function get content():UIComponent
        {
            return(__content);
        }

        public function set content(value:UIComponent):void
        {
            if (value != __content)
            {
                if (__content != null)
                {
                    if (contains(__content))
                    {
                        removeChild(__content);
                    }

                    __content.destroy();
                }
                __content = value;
                addChild(__content);
                invalidateDisplayList();
            }
        }

        public function get titleBar():TitleBar
        {
            return( __titleBar );
        }

        public function set titleBar(value:TitleBar):void
        {
            if (value != __titleBar)
            {
                if (__titleBar != null)
                {
                    if (contains(__titleBar))
                    {
                        removeChild(__titleBar);
                    }

                    __titleBar.destroy();
                }

                __titleBar = value;
                addChild(__titleBar);
                invalidateDisplayList();
            }
        }

        public function Page()
        {
            super();
        }

        override protected function commitProperties():void
        {
            super.commitProperties();

            createActionBar();

            setActionBarVisibility(actionBar != null);
        }

        override protected function createActionBar():void
        {
            if (paneProperties is NavigationPaneProperties)
            {
                var back:Action = NavigationPaneProperties(paneProperties).backButton;
                if (back != null)
                {
                    super.createActionBar();
                    if (actionBar)
                    {
                        actionBar.backButton = back;
                        actionBar.enableBackButtonDrag = true;
                        actionBar.addEventListener(DragEvent.DRAG_BEGIN, onBackDragBegin);
                        actionBar.addEventListener(DragEvent.DRAG_MOVE, onBackDragMove);
                        actionBar.addEventListener(DragEvent.DRAG_END, onBackDragEnd);
                    }
                }
                else
                {
                    removeDragListeners();
                }
            }
        }

        private function removeDragListeners():void
        {
            if (actionBar)
            {
                actionBar.enableBackButtonDrag = false;
                actionBar.removeEventListener(DragEvent.DRAG_BEGIN, onBackDragBegin);
                actionBar.removeEventListener(DragEvent.DRAG_MOVE, onBackDragMove);
                actionBar.removeEventListener(DragEvent.DRAG_END, onBackDragEnd);
            }
        }

        private function onBackDragBegin(event:DragEvent):void
        {
            __backButtonDragging = true;
            __slideX = this.x;
        }

        private function onBackDragEnd(event:DragEvent):void
        {
            if (this.x / stage.stageWidth > .6)
            {
                popAndDeletePage();
            }
            else
            {
                var t:Number = this.x / 2000;
                Tweener.addTween(this, {x: 0, time: t, transition: "easeOutCubic", onComplete: closeComplete });
            }
        }

        private function closeComplete():void
        {
            __backButtonDragging = false;
        }

        private function onBackDragMove(event:DragEvent):void
        {
            __slideX += event.deltaX;
            this.x = Math.max(0, __slideX);
        }

        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);

            var contenty:Number = 0;

            if (__titleBar)
            {
                __titleBar.width = unscaledWidth;
                contenty = __titleBar.height;
            }

            if (__content)
            {
                __content.y = contenty;
                __content.width = unscaledWidth;
                __content.height = getContentHeight() - contenty;
            }
        }

        override public function onActionSelected(action:ActionBase):void
        {
            if (actionBar != null && action == actionBar.backButton && !__backButtonDragging)
            {
                popAndDeletePage();
            }

            __backButtonDragging = false;
        }

        override public function getActionsToDisplayOnBar():Vector.<Action>
        {
            if (actions)
            {
                return(actions);
            }

            return (super.getActionsToDisplayOnBar());
        }


        override protected function popAndDeletePage():void
        {
            removeDragListeners();
            super.popAndDeletePage();
        }
    }
}
