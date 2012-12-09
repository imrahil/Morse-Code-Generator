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
    import qnx.fuse.ui.events.NavigationEvent;

    /**
     * @author juliandolce
     */
    public class NavigationPane extends BasePane
    {
        private var __stack:Vector.<Page> = new Vector.<Page>();
        private var __backButtonsVisible:Boolean = true;

        public function get stack():Vector.<Page>
        {
            return( __stack );
        }

        public function get top():Page
        {
            return( __stack[ __stack.length - 1 ] );
        }

        public function get backButtonsVisible():Boolean
        {
            return( __backButtonsVisible );
        }

        public function set backButtonsVisible(value:Boolean):void
        {
            if (__backButtonsVisible != value)
            {
                __backButtonsVisible = value;
            }
        }

        public function NavigationPane()
        {
        }

        override protected function init():void
        {
            super.init();
        }

        public function pop():void
        {
            popPane();
        }

        public function popAndDelete():void
        {
            popPane(true);
        }

        private function popPane(callDestroy:Boolean = false):void
        {
            var pane:Page = __stack.pop();

            if (__stack.length == 0)
            {
                transitionOutComplete(pane, callDestroy);
            }
            else
            {
                var t:Number = (width - pane.x) / 2000;
                Tweener.addTween(pane, {x: width, time: t, transition: "easeOutCubic", onComplete: transitionOutComplete, onCompleteParams: [pane, callDestroy]});
            }
        }

        public function push(pane:Page):void
        {
            var animate:Boolean = __stack.length > 0;

            __stack.push(pane);
            pane.width = width;
            pane.height = height;

            dispatchEvent(new NavigationEvent(NavigationEvent.POP));
            addChild(pane);

            if (animate)
            {
                pane.x = width;
                Tweener.addTween(pane, {x: 0, time: pane.x / 2000, transition: "easeOutCubic", onComplete: transitionInComplete, onCompleteParams: [pane]});
            }
            else
            {
                transitionInComplete(pane);
            }
        }

        private function transitionInComplete(pane:Page):void
        {
            pane.dispatchEvent(new NavigationEvent(NavigationEvent.TRANSITION_IN_COMPLETE));
        }

        private function transitionOutComplete(pane:Page, callDestroy:Boolean = false):void
        {
            removeChild(pane);
            if (callDestroy)
            {
                pane.destroy();
            }
        }

        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            //will have to figure something out here.

            for (var i:int = 0; i < __stack.length; i++)
            {
                __stack[ i ].width = unscaledWidth;
                //TODO height gets set by the parent most likely.
                //Need to add case where it is not and set the height as well.
            }
        }

        override public function onActionSelected(action:ActionBase):void
        {
            if (top)
            {
                top.onActionSelected(action);
            }
            else
            {
                super.onActionSelected(action);
            }
        }

        override public function getActionsToDisplayOnBar():Vector.<Action>
        {
            if (top && top.actions)
            {
                return( top.actions );
            }

            return( super.getActionsToDisplayOnBar() );
        }

    }
}
