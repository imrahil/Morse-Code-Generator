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

	import qnx.fuse.ui.core.ActionBase;
	import qnx.fuse.ui.events.NavigationEvent;

	/**
	 * A class that is used for stack-like navigation between <code>Page</code> objects.
	 * <p>
	 * The <code>NavigationPane</code> keeps track of a stack of <code>Page</code> objects that can be pushed and popped on the stack. 
	 * Only the topmost page on the stack is displayed to the user. 
	 * The <code>push()</code> function adds a new page on the top of the navigation stack, displaying it while hiding the old page. 
	 * The <code>pop()</code> function hides the page currently on the top of the stack, removing it from the navigation stack and displaying the previous page again.
	 * </p>
	 * @see #push()
	 * @see #pop()
	 */
	public class NavigationPane extends BasePane
	{
		private var __stack:Vector.<Page> = new Vector.<Page>();
		private var __backButtonsVisible:Boolean = true;
		
		/**
		 * Gets the current stack of this <code>NavigationPane</code>.
		 */
		public function get stack():Vector.<Page>
		{
			return( __stack );
		}
		
		/**
		 * The topmost page on the stack of this <code>NavigationPane</code>.
		 * <p>
		 * This is the page that is currently displayed.
		 * </p>
		 */
		public function get top():Page
		{
			return( __stack[ __stack.length - 1 ] );
		}
		
		
		/**
		 * Indicates whether the back buttons should be visible on all pushed pages in this NavigationPane.
		 * <p>
		 * The back button can be set on individual pages. The back button is never visible on the first page. 
		 * This property is <code>true</code> by default (back buttons are visible). 
		 * If no back button has been set on the current page, a default back button is used. 
		 * The default back button pops the current page and deletes it when the button is clicked.
		 * </p>
		 * @default true
		 */
		public function get backButtonsVisible():Boolean
		{
			return( __backButtonsVisible );
		}
		
		public function set backButtonsVisible( value:Boolean ):void
		{
			if( __backButtonsVisible != value )
			{
				__backButtonsVisible = value;
			}
		}
		
		/**
		 * Creates a <code>NavigationPane</code> instance.
		 */
		public function NavigationPane()
		{
		}
		
		/** @private **/
		override protected function init():void
		{
			super.init();
			removeBackground();
			opaqueBackground = null;
		}
		
		/**
		 * Pops the top page from the stack of this <code>NavigationPane</code>.
		 */
		public function pop():void
		{
			popPane();
		}
		
		/**
		 * Pops the top page from the stack of this <code>NavigationPane</code> and destorys it.
		 * <p>
		 * After the page has completed the out transition, the <code>destory()</code> function of the page will be called.
		 * </p>
		 */
		public function popAndDelete():void
		{
			popPane( true );
		}
		
		private function popPane( callDestroy:Boolean = false ):void
		{
			var pane:Page = __stack.pop();
			
			if( __stack.length == 0 )
			{
				transitionOutComplete( pane, callDestroy );
			}
			else
			{
				var t:Number = (width-pane.x)/2000;
				Tweener.addTween( pane, {x:width, time:t, transition:"easeOutCubic", onComplete:transitionOutComplete, onCompleteParams:[pane,callDestroy]} );
			}
			
		}
		
		/**
		 * Pushes a new page onto the stack of this <code>NavigationPane</code>.
		 * <p>
		 * The pushed page is placed on the top of the navigation stack, and is displayed to the user. 
		 * </p>
		 * @param pane The page to push onto the stack.
		 */
		public function push( pane:Page ):void
		{
			var animate:Boolean = __stack.length > 0;
			
			__stack.push( pane );
			pane.width = width;
			pane.height = height;
			
			dispatchEvent(new NavigationEvent(NavigationEvent.POP));
			addChild( pane );

			if( animate )
			{
				pane.x = width;
				Tweener.addTween( pane, {x:0, time:pane.x/2000, transition:"easeOutCubic", onComplete:transitionInComplete, onCompleteParams:[pane]} );
			}
			else
			{
				transitionInComplete( pane );
			}
			
		}
		
		/**
		 * Gets the index in stack of the specified page.
		 * @param page The page to get the index of.
		 * @return Returns the index of the page in the stack. If the page is not in the stack, -1 is returned.
		 */
		public function getPageIndex( page:Page ):int
		{
			for( var i:int = 0; i<__stack.length; i++ )
			{
				if( __stack[ i ] == page )
				{
					return( i );
				}
			}
			
			return( -1 );
		}
		
		private function transitionInComplete( pane:Page ):void
		{
			pane.dispatchEvent(new NavigationEvent( NavigationEvent.TRANSITION_IN_COMPLETE ));
		}
		
		private function transitionOutComplete( pane:Page, callDestroy:Boolean = false ):void
		{
			removeChild( pane );
			if( callDestroy )
			{
				pane.destroy();
			}
		}
		
		/** @private **/
		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
		{
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			//will have to figure something out here.
			
			var setHeight:Boolean = !(parent is TabbedPane);
			
			for( var i:int = 0; i<__stack.length; i++ )
			{
				__stack[ i ].width = unscaledWidth;
				if( setHeight )
				{
					__stack[ i ].height = unscaledHeight;
				}
			}
		}
		
		/** @private **/
		override public function onActionSelected( action:ActionBase ):void
		{
			if( top )
			{
				top.onActionSelected(action);
			}
			else
			{
				super.onActionSelected( action );
			}
		}
		
		/** @private **/
		override public function getActionsToDisplayOnBar():Vector.<ActionBase>
		{
			if( top && top.actions )
			{
				return( top.actions );
			}
			
			return( super.getActionsToDisplayOnBar() );
		}
		
		/** @private **/
		override public function softKeyboardActivated():void
		{
			super.softKeyboardActivated();
			top.softKeyboardActivated();
		}
		
		/** @private **/
		override public function softKeyboardDeactivated():void
		{
			super.softKeyboardDeactivated();
			top.softKeyboardDeactivated();
		}
		
		
		/** @private **/	
		override public function destroy():void
		{
			__stack.length = 0;
			super.destroy();
		}

	}
}
