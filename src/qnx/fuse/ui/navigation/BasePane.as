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
	import qnx.fuse.ui.core.ActionBase;
	import qnx.fuse.ui.core.UIComponent;
	import qnx.fuse.ui.events.ActionEvent;
	import qnx.fuse.ui.events.NavigationEvent;
	import qnx.fuse.ui.theme.ThemeGlobals;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;

	/**
	 * A base class that provides functionality for inherited page and pane classes.
	 * <p>
	 * Only classes deriving from the <code>BasePane</code> class can be set as the root component of an application. This means that every application will have at least one object that derives from <code>BasePane</code>.
	 * </p>
	 * <p>
	 * <code>BasePane</code> has an attribute called <code>paneProperties</code>, which contains properties used for visual representation within its parent. 
	 * The type of pane properties of the child must match up with parent. For example, if you add a <code>Page</code> to a <code>NavigationPane</code>, the <code>Page</code> must use <code>NavigationPaneProperties</code>.
	 * </p>
	 * @see qnx.fuse.ui.Application#scene
	 * @see Page
	 * @see NavigationPane
	 * @see #paneProperties
	 **/
	public class BasePane extends UIComponent
	{
		private var __background:Bitmap;
		static private var BGBitmapData:BitmapData = new BitmapData( 5, 5, true, 0x00000000 );
		static private var ContentCoverBitmapData:BitmapData = new BitmapData( 5, 5, false, 0xFF000000 );
		
		/**
		 * Content cover is used to dim the content when peeking occurs.
		 */
		protected var contentCover:DisplayObject;
		
		/**
		 * Represents the <code>ActionBar</code> associated on the pane.
		 */
		protected var actionBar:ActionBar;
		
		private var __paneProperties:PaneProperties;
		
		/**
		 * There is a need to mask the action bar because it has a 1px transparent border.
		 * This causes opaque backgrounds to appear larger then they should.
		 */
		private var __actionbarMask:Sprite;
		
		/**
		 * The pane properties for this pane.
		 * <p>
		 * The <code>paneProperties</code> property specifies data that the parent <code>BasePane</code> may use. 
		 * The type of pane properties of the child must match up with parent. For example, if you add a <code>Page</code> to a <code>NavigationPane</code>, you must use <code>NavigationPaneProperties</code>.
		 * </p>
		 */
		public function get paneProperties():PaneProperties
		{
			return( __paneProperties );
		}
		
		public function set paneProperties( value:PaneProperties ):void
		{
			if( __paneProperties != value )
			{
				__paneProperties = value;
				invalidateProperties();
				invalidateDisplayList();
			}
		}

		/**
		 * Creates a <code>BasePane</code> instance.
		 */
		public function BasePane()
		{
		}
		
		/** @private **/
		override protected function init():void
		{
			__background = new Bitmap( BGBitmapData );
			addChildAt( __background, 0 );
			opaqueBackground = ( ThemeGlobals.currentTheme == ThemeGlobals.WHITE ) ? 0xFFFFFF : 0x121212;

			super.init();
			
			addEventListener(NavigationEvent.TRANSITION_IN_COMPLETE, transitionInComplete );
			addEventListener(NavigationEvent.TRANSITION_OUT_COMPLETE, transitionOutComplete );
		}
		
		/**
		 * @private
		 */
		protected function removeBackground():void
		{
			if( __background && contains( __background ) )
			{
				removeChild( __background );
			}
		}
		
		/** @private **/
		protected function createContentCover():void
		{
			if( contentCover == null )
			{
				contentCover = new Bitmap( ContentCoverBitmapData );
				sizeContentCover();
			}
		}
		
		private function transitionInComplete( event:NavigationEvent ):void
		{
			onTransitionInComplete();
		}
		
		/**
		 * Is called when the pane has transitioned in.
		 */
		protected function onTransitionInComplete():void
		{
			
		}
		
		private function transitionOutComplete( event:NavigationEvent ):void
		{
			onTransitionOutComplete();
		}
		
		/**
		 * Is called when the pane has transitioned out.
		 */
		protected function onTransitionOutComplete():void
		{
			
		}
		
		private function actionSelected( event:ActionEvent ):void
		{
			onActionSelected( event.action );
		}
		
		/**
		 * Is called when a action is selected on the action bar associated with this pane.
		 * @param action The action that was selected.
		 */
		public function onActionSelected( action:ActionBase ):void
		{
			
		}
		
		/** @private **/
		protected function createActionBar():void
		{
			//Do some checks here to figure out if we need one or not.
			
			actionBar = new ActionBar();
			actionBar.addEventListener(ActionEvent.ACTION_SELECTED, actionSelected );
			
			//The action bar is masked so the pane can have an opaque background.
			//There is a pixel of transparency around the action bar assets which causes issues with the opaque background.
			__actionbarMask = new Sprite();
			var g:Graphics = __actionbarMask.graphics;
			g.beginFill( 0xFF0000 );
			g.drawRect(0, 0, 10, 10);
			g.endFill();
			
			actionBar.mask = __actionbarMask;
			
		}
		
		/** @private **/
		protected function setActionBarVisibility( value:Boolean ):void
		{
			if( actionBar )
			{
			
				if( value )
				{
					addChild( actionBar );
					addChild( __actionbarMask );
				}
				else
				{
					if( contains( actionBar ) )
					{
						removeChild( actionBar );
						removeChild( __actionbarMask );
					}
				}
			}
		}
		
		/** @private **/
		protected function getContentHeight():Number
		{
			if( actionBar && contains( actionBar ) )
			{
				return( actionBar.y );
			}
			
			return( height );
		}
		
		/** @private **/	
		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
		{
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			if( __background )
			{
				__background.width = unscaledWidth;
				__background.height = unscaledHeight;
			}
			
			if( actionBar )
			{
				actionBar.width = unscaledWidth;
				actionBar.y = unscaledHeight - actionBar.height;
				
				__actionbarMask.width = actionBar.width;
				__actionbarMask.height = actionBar.height;
				__actionbarMask.x = actionBar.x;
				__actionbarMask.y = actionBar.y;
				
			}
			
			sizeContentCover();
		}
		
		private function sizeContentCover():void
		{
			if( contentCover )
			{
				contentCover.width = width;
				contentCover.height = getContentHeight();
			}
		}
		
		
		/**
		 * Pops the top most pane if the parent is a <code>NavigationPane</code>.
		 */
		protected function popPage():void
		{
			var navPane:NavigationPane = getNavPane();
			if( navPane )
			{
				navPane.pop();
			}
		}
		
		/**
		 * Pops and then deletes the top most pane if the parent is a <code>NavigationPane</code>.
		 */
		protected function popAndDeletePage():void
		{
			var navPane:NavigationPane = getNavPane();
			if( navPane )
			{
				navPane.popAndDelete();
			}
		}
		
		/**
		 * Pushes a new page onto the stack if the parent is a <code>NavigationPane</code>.
		 */
		protected function pushPage( pane:Page ):void
		{
			var navPane:NavigationPane = getNavPane();
			if( navPane )
			{
				navPane.push( pane );
			}
		}
		
		private function getNavPane():NavigationPane
		{
			if( parent != null )
			{
				var navPane:NavigationPane = parent as NavigationPane;
				return( navPane );
			}
			
			return( null );
		}
		
		
		/**
		 * @private
		 * This is called by navigation classes to determine what actions to show on its <code>ActionBar</code> when the page has focus.
		 */
		public function getActionsToDisplayOnBar():Vector.<ActionBase>
		{
			return( new Vector.<ActionBase>() );
		}
		
		/** @private **/	
		override public function destroy():void
		{
			removeEventListener(NavigationEvent.TRANSITION_IN_COMPLETE, transitionInComplete );
			removeEventListener(NavigationEvent.TRANSITION_OUT_COMPLETE, transitionOutComplete );
			
			if( actionBar )
			{
				actionBar.removeEventListener(ActionEvent.ACTION_SELECTED, actionSelected );
			}
			super.destroy();
		}
		
		/**
		 * Called by the <code>Application</code> class when the keyboard is activated.
		 * <p>
		 * When an applications softKeyboardBehavior is set to none, 
		 * the <code>Application</code> class will call this method in order to resize the content
		 * so it fits above the keyboard.
		 * </p>
		 */
		public function softKeyboardActivated():void
		{
			
		}
		
		/**
		 * Called by the <code>Application</code> class when the keyboard is hidden.
		 * <p>
		 * When an applications softKeyboardBehavior is set to none, 
		 * the <code>Application</code> class will call this method in order to resize the content
		 * to the correct height.
		 * </p>
		 */
		public function softKeyboardDeactivated():void
		{
			
		}

	}
}
