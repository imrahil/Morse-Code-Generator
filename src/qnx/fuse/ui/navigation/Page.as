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
	 * Defines an individual screen within an application.
	 * <p>
	 * On a <code>Page</code> it's possible to specify a root control and a set of actions. 
	 * The actions are displayed on the Action Bar placed at the bottom of the screen. 
	 * If no actions are specified, the Action bar will not be displayed, and the screen content assumes the full height of the screen. 
	 * As soon as one or more actions are added, the Action bar will appear.
	 * </p>
	 */
	public class Page extends BasePane
	{
		
		private var __actions:Vector.<ActionBase>;
		private var __content:UIComponent;
		private var __titleBar:TitleBar;
		private var __slideX:Number = 0;
		private var __backButtonDragging:Boolean;
		
		/**
		 * Gets or sets a list of actions associated with this <code>Page</code>.
		 */
		public function get actions():Vector.<ActionBase>
		{
			return( __actions );
		}
		
		public function set actions( value:Vector.<ActionBase> ):void
		{
			if( __actions != value )
			{
				__actions = value;
				invalidateProperties();
			}
		}
		
		/**
		 * The content of the page.
		 * <p>
		 * The content is displayed and resized to fit below the title bar and above the action bar if they exist.
		 * If neither are present, the content is resized to fill the entire screen.
		 * </p>
		 */
		public function get content():UIComponent
		{
			return( __content );
		}
		
		public function set content( value:UIComponent ):void
		{
			if( value != __content )
			{
				
				if( __content != null )
				{
					if( contains( __content  ) )
					{
						removeChild( __content  );
					}
					
					__content.destroy();
				}
				__content = value;
				addChild( __content );
				invalidateDisplayList();
			}
		}
		
		/**
		 * Gets or sets the title bar of the page.
		 * <code>
		 * The title bar is placed at the very top of the page.
		 * </code>
		 */
		public function get titleBar():TitleBar
		{
			return( __titleBar );	
		}
		
		public function set titleBar( value:TitleBar ):void
		{
			if( value != __titleBar )
			{
				if( __titleBar != null )
				{
					if( contains( __titleBar  ) )
					{
						removeChild( __titleBar  );
					}
					
					__titleBar.destroy();
				}
				
				__titleBar = value;
				addChild( __titleBar );
				invalidateDisplayList();
			}
		}
		
		/**
		 * Creates a new <code>Page</code> instance.
		 */
		public function Page()
		{
			super();
		}
		
		/** @private **/
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			createActionBar();
			
			setActionBarVisibility( actionBar != null );
		}
		
		/** @private **/
		override protected function createActionBar():void
		{
			if( __actions && __actions.length > 0 )
			{
				//If we are in a tabbed pane, the tabbed pane gets the actions
				// and we shouldn't create an action bar.
				if( parent && !( parent is TabbedPane ) )
				{
					super.createActionBar();
					addActionsToBar();
				}
			}
			
			
			if( parent && ( parent is NavigationPane ) )
			{
				var back:Action;
				
				if( paneProperties is NavigationPaneProperties )
				{
					back = NavigationPaneProperties( paneProperties ).backButton;
				}
				
				if( back == null )
				{
					if( parent != null )
					{
						var navPane:NavigationPane = parent as NavigationPane;
						if( navPane && navPane.backButtonsVisible )
						{
							var title:String = "Back";
							
							var currentIndex:int = navPane.getPageIndex( this );
							if( currentIndex > 0 )
							{
								var index:int = Math.max( 0, currentIndex - 1 );
								
								var page:Page = navPane.stack[ index ];
								if( page )
								{
									if( page.titleBar && page.titleBar.title && page.titleBar.title.length > 0 )
									{
										title = page.titleBar.title;
									}
								}
								back = new Action( title );
							}
						}
					}
				}
				
				if( back != null )
				{
					if( !actionBar )
					{
						//This handles the case where there are no actions and just a back button.
						super.createActionBar();
					}
					
					if( actionBar )
					{
						actionBar.backButton = back;
						actionBar.enableBackButtonDrag = true;
						actionBar.addEventListener(DragEvent.DRAG_BEGIN, onBackDragBegin );
						actionBar.addEventListener(DragEvent.DRAG_MOVE, onBackDragMove );
						actionBar.addEventListener(DragEvent.DRAG_END, onBackDragEnd );
					}
					
				}
				else
				{
					removeDragListeners();
				}
			}
		}
		
		private function addActionsToBar():void
		{
			if( actionBar && __actions && __actions.length > 0 )
			{
				actionBar.removeAll();
				actionBar.addActionsAt(__actions, 0);
			}
		}
		
		private function removeDragListeners():void
		{
			if( actionBar )
			{
				actionBar.enableBackButtonDrag = false;
				actionBar.removeEventListener(DragEvent.DRAG_BEGIN, onBackDragBegin );
				actionBar.removeEventListener(DragEvent.DRAG_MOVE, onBackDragMove );
				actionBar.removeEventListener(DragEvent.DRAG_END, onBackDragEnd );
			}
		}

		private function onBackDragBegin( event:DragEvent ):void
		{
			__backButtonDragging = true;
			__slideX = this.x;
		}

		private function onBackDragEnd( event:DragEvent ):void
		{
			if( this.x/stage.stageWidth > .6 )
			{
				popAndDeletePage();
			}
			else
			{
				var t:Number = this.x/2000;
				Tweener.addTween( this, {x:0, time:t, transition:"easeOutCubic", onComplete:closeComplete } );
			}
		}
		
		private function closeComplete():void
		{
			__backButtonDragging = false;
			
			if( contentCover )
			{
				contentCover.alpha = 0;
				if( contains(contentCover) )
				{
					removeChild(contentCover);
					contentCover = null;
				}
			}
		}

		private function onBackDragMove( event:DragEvent ):void
		{
			__slideX += event.deltaX;
			this.x = Math.max( 0, __slideX );
			
			var percent:Number = this.x/stage.stageWidth;
			
			if( percent > .5 )
			{
				if( contentCover == null )
				{
					createContentCover();
					addChild( contentCover );
				}
				
				contentCover.alpha = percent - 0.5;
			}
			else
			{
				if( contentCover )
				{
					contentCover.alpha = 0;
				}
			}
		}
		
		/** @private **/
		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
		{
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			var contenty:Number = 0;
			
			if( __titleBar )
			{
				__titleBar.width = unscaledWidth;
				contenty = __titleBar.height;
			}
			
			var contentHeight:Number = getContentHeight() - contenty;
			
			if( __content )
			{
				__content.y = contenty;
				__content.width = unscaledWidth;
				__content.height = contentHeight;				
			}
		}
		
		/** @private **/
		override public function onActionSelected( action:ActionBase ):void
		{
			if( actionBar != null && action == actionBar.backButton && !__backButtonDragging )
			{
				popAndDeletePage();
			}
			
			__backButtonDragging = false;
		}
		
		/** @private **/
		override public function getActionsToDisplayOnBar():Vector.<ActionBase>
		{
			if( actions )
			{
				return( actions );
			}
			
			return( super.getActionsToDisplayOnBar() );
		}
		
		/** @private **/
		override protected function popAndDeletePage():void
		{
			removeDragListeners();
			super.popAndDeletePage();
		}
		
		/** @private **/	
		override public function destroy():void
		{
			removeDragListeners();
			if( __actions )
			{
				__actions.length = 0;
			}
			super.destroy();
		}
		
		/** @private **/
		override public function softKeyboardActivated():void
		{
			super.softKeyboardActivated();
			content.height = height - stage.softKeyboardRect.height - content.y;
		}
		
		/** @private **/
		override public function softKeyboardDeactivated():void
		{
			super.softKeyboardDeactivated();
			content.height = getContentHeight() - content.y;
			
		}

	}
}
