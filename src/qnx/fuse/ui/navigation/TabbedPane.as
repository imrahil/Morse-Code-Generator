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
	import qnx.fuse.ui.core.TabAction;
	import qnx.fuse.ui.events.DragEvent;
	import qnx.fuse.ui.events.NavigationEvent;

	import flash.display.DisplayObjectContainer;

	/**
	 * A navigation control that allows the user to switch between tabs.
	 * <p>
	 * The tabs can be used to either completely replace displayed content by setting new panes or to filter existing content in a single pane based on which tab is currently selected.
	 * </p>
	 * <p>
	 * The <code>Tab</code> objects in the <code>TabbedPane</code> are added to the Action bar, which is a horizontal bar displayed at the bottom of the screen. 
	 * The tabs on the Action bar can be pressed to switch to display their content. 
	 * The Tab objects take an <code>BasePane</code> as their content. If the content is not <i>null</i>, it will be displayed in the <code>TabbedPane</code> when the corresponding tab is selected.
	 * </p>
	 * <p>
	 * If the <code>TabbedPane</code> has only one <code>Tab</code> and the content of that <code>Tab</code> has no actions, the Action bar is not displayed since there aren't any additional tabs or actions to be displayed.
	 * </p>
	 * <p>
	 * The first added <code>Tab</code> becomes the active one.
	 * </p>
	 * <p>
	 * If the content of the <code>Tab</code> that is being displayed has any <code>Action</code> objects associated with it, 
	 * these actions take priority and are placed on the Action bar, while the other tabs are pushed to the tab overflow menu. 
	 * This behavior can be changed by setting the <code>showTabsOnActionBar</code> property to <i>true</i>. 
	 * If <code>showTabsOnActionBar</code> is <i>true</i>, tabs will be placed on the Action bar and actions will be placed in the action overflow menu.
	 * </p>
	 * <p>
	 * The user can access tabs or actions that are not present on the Action bar by pressing the overflow tab, which is automatically added to the Action bar when it is needed.
	 * </p>
	 * <p>
	 * If a tab is selected that is not currently present on the Action bar, the side bar will then change to the active-tab state and show the title and image of that tab along with an overflow symbol.
	 * </p>
	 */
	public class TabbedPane extends BasePane
	{

		private var __tabs:Vector.<Tab>;
		private var __actions:Vector.<ActionBase>;
		private var __activeTab:Tab;
		private var __tabsChanged:Boolean;
		private var __activeTabChanged:Boolean;
		
		private var __activePane:BasePane;
		private var __tabOverFlowParent:DisplayObjectContainer;
		private var __slideX:Number = 0;
		private var __showTabsOnActionBar:Boolean = true;
		
		/**
		 * Specifies wether tabs or actions get priority on the action bar.
		 * <p>
		 * When set to <i>true</i>, which is the default, tabs are shown on the bar. 
		 * When set to <i>false</i>, all tabs are shown in the tab overflow menu.
		 * </p>
		 * @default true
		 */
		public function get showTabsOnActionBar():Boolean
		{
			return( __showTabsOnActionBar );
		}
		
		public function set showTabsOnActionBar( value:Boolean ):void
		{
			if( value != __showTabsOnActionBar )
			{
				__showTabsOnActionBar = value;
				invalidateProperties();
			}
		}
		
		/**
		 * The container for which the tab overflow menu should appear in.
		 * <p>
		 * If added as the scene for your application, this property is set automatically for you.
		 * </p>
		 */
		public function get tabOverflowParent():DisplayObjectContainer
		{
			return( __tabOverFlowParent );
		}
		
		public function set tabOverflowParent( value:DisplayObjectContainer ):void
		{
			if( __tabOverFlowParent != value )
			{
				__tabOverFlowParent = value;
				if( actionBar )
				{
					actionBar.tabOverflowParent = value;
				}
			}
		}
		
		/**
		 * The <code>Tab</code> that is currently active in the <code>TabbedPane</code>.
		 */
		public function get activeTab():Tab
		{
			return( __activeTab );
		}
		
		public function set activeTab( value:Tab ):void
		{
			if( __activeTab != value )
			{
				var index:int = __tabs.indexOf( value );
				if( index != -1 )
				{
					__activeTab = value;
					__activeTabChanged = true;
					invalidateProperties();
				}
			}
		}
		
		/**
		 * Gets or sets the tabs to be displayed on the action bar.
		 */
		public function get tabs():Vector.<Tab>
		{
			return( __tabs );
		}
		
		public function set tabs( value:Vector.<Tab> ):void
		{
			if( __tabs != value )
			{
				__tabs = value;
				__tabsChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * Creates a <code>TabbedPane</code> instance.
		 */
		public function TabbedPane()
		{
			super();
		}
		
		/** @private **/
		override protected function commitProperties():void
		{
			super.commitProperties();
			if( __tabsChanged )
			{
				updateActionBar();
				__tabsChanged = false;
			}
			
			if( __activeTabChanged )
			{
				for( var i:int = 0; i<actionBar.totalItems; i++ )
				{
					var action:TabAction = actionBar.getActionAt(i) as TabAction;
					if( action )
					{
						if( Tab( action.data ) == __activeTab )
						{
							actionBar.selectedTabAction = action;
							break;
						}
					}
				}
				addTabbedPane();
				__activeTabChanged = false;
			}
			
			if( actionBar )
			{
				actionBar.showTabsFirstOnBar( __showTabsOnActionBar );
			}
		}
		
		/** @private **/
		override protected function createActionBar():void
		{
			if( __tabs != null && __tabs.length > 0 )
			{
				super.createActionBar();
				if( actionBar )
				{
					actionBar.tabOverflowParent = __tabOverFlowParent;
					actionBar.reserveActionSpace(true);
					actionBar.addEventListener(DragEvent.DRAG_MOVE, onDragMove );
					actionBar.addEventListener(DragEvent.DRAG_END, onDragEnd );
				}
			}
		}

		private function onDragEnd( event:DragEvent ):void
		{
			var percent:Number = this.x/stage.stageWidth;
			if( percent < 0.5 )
			{
				if( contentCover && contains( contentCover ) )
				{
					removeChild( contentCover );
					contentCover = null;
				}
			}
		}

		private function onDragMove( event:DragEvent ):void
		{
			__slideX += event.deltaX;
			this.x = Math.round(__slideX + stage.stageWidth);
			
			
			
			var percent:Number = this.x/stage.stageWidth;
			
			if( contentCover == null )
			{
				createContentCover();
				addChild( contentCover );
			}
			
			var a:Number = Math.max( 0, percent - 0.3 );
			
			contentCover.alpha =  a;
		}
		
		private function updateActionBar():void
		{
			if( __tabs != null )
			{
				createActionBar();
				
				if( actionBar )
				{
					actionBar.removeAll();
					
					for( var i:int = 0; i<__tabs.length; i++ )
					{
						var tab:Tab = __tabs[ i ];
						//TODO currently the Tab is the data object.
						//We probably want to make TabAction the Tab class in the future.
						//But TabAction is final.
						actionBar.addAction( new TabAction( tab.label, tab.icon, tab  ) );
					}
				}
			}
		}
		
		private function addTabbedPane():void
		{
			var showBar:Boolean = false;
			if( actionBar )
			{
				showBar = actionBar.totalItems > 0;
			}
			
			setActionBarVisibility( showBar );
			
			var animate:Boolean = false;
			
			var oldPane:BasePane;
			if( __activePane != null )
			{
				if( __activePane is NavigationPane )
				{
					__activePane.removeEventListener( NavigationEvent.POP, pagedPopped );
				}
				
				if( contains( __activePane ) )
				{
					//TODO handle some sort of animation here
					animate = true;
					oldPane = __activePane;
					Tweener.removeTweens( oldPane );
				}
				
				
			}
				
			if( __activeTab )
			{	
				
				if( __activeTab.content == null )
				{
					//TODO should probably handle the case where the content and contentClass are both null.
					var pane:BasePane = new __activeTab.contentClass() as BasePane;
					__activeTab.content = pane;
				}
				
				
				__activePane = __activeTab.content;

				resizeActivePane();
				
				if( __activePane is NavigationPane )
				{
					__activePane.addEventListener( NavigationEvent.POP, pagedPopped );
				}
				
				
				
				addChild( __activePane );
				if( animate )
				{
					__activePane.alpha = 0;
					Tweener.addTween( oldPane, {alpha:0, time:0.5} );
					Tweener.addTween( __activePane, {alpha:1, time:0.5, onComplete:inAnimationComplete, onCompleteParams:[oldPane]} );
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
			
			if( oldPane != null && contains( oldPane ) )
			{
				removeChild( oldPane );
			}
			__activePane.dispatchEvent( new NavigationEvent( NavigationEvent.TRANSITION_IN_COMPLETE ) );
		}
		
		private function removeAndUpdateActions():void
		{
			var i:int = 0;
			if( __actions && actionBar )
			{
				for( i = 0; i<__actions.length; i++ )
				{
					actionBar.removeAction( __actions[ i ] );
				}
				
				__actions = null;
			}
			
			
			__actions = getActionsToDisplayOnBar();
				
			if( __actions && actionBar )
			{
				for( i = 0; i<__actions.length; i++ )
				{
					actionBar.addAction(__actions[ i ] );
				}
			}
		}
		
		//TODO does this still need to happen. Sizes shouldn't change when something is popped off.
		private function pagedPopped( event:NavigationEvent ):void
		{
			var navPane:NavigationPane = event.target as NavigationPane;
			sizeNavigationPaneStack( navPane );
		}
		
		private function sizeNavigationPaneStack( pane:NavigationPane ):void
		{
			
			for( var i:int = 0; i<pane.stack.length; i++ )
			{
				var page:Page = pane.stack[ i ];
				page.width = width;
				var h:Number = ( i == 0 ) ? getContentHeight() : height;
				page.height = h;
			}
		}
		
		private function resizeActivePane():void
		{
			__activePane.width = width;
				
			if( __activePane is NavigationPane )
			{
				__activePane.height = height;
				sizeNavigationPaneStack( __activePane as NavigationPane );
			}
			else
			{
				__activePane.height = getContentHeight();
			}
		}
		
		/** @private **/
		override public function onActionSelected( action:ActionBase ):void
		{
			if( action is TabAction )
			{
				activeTab = Tab( action.data );
			}
			else if( action is Action )
			{
				__activePane.onActionSelected(action);
			}
		}
		
		/** @private **/
		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
		{
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			if( __activePane )
			{
				resizeActivePane();
			}
		}
		
		/** @private **/
		override public function getActionsToDisplayOnBar():Vector.<ActionBase>
		{
			if( __activePane )
			{
				return( __activePane.getActionsToDisplayOnBar() );
			}
			
			return( super.getActionsToDisplayOnBar() );
		}
		
		/** @private **/
		override public function softKeyboardActivated():void
		{
			super.softKeyboardActivated();
			__activePane.softKeyboardActivated();
		}
		
		/** @private **/
		override public function softKeyboardDeactivated():void
		{
			super.softKeyboardDeactivated();
			__activePane.softKeyboardDeactivated();
		}
		
		
		
		/** @private **/	
		override public function destroy():void
		{
			__actions.length = 0;
			__tabs.length = 0;
			if( actionBar )
			{
				actionBar.removeEventListener(DragEvent.DRAG_MOVE, onDragMove );
				actionBar.removeEventListener(DragEvent.DRAG_END, onDragEnd );
			}
			
			if( __activePane )
			{
				__activePane.removeEventListener( NavigationEvent.POP, pagedPopped );
				__activePane = null;
			}
			
			__activeTab = null;
			
			super.destroy();
		}

	}
}
