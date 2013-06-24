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
package qnx.fuse.ui
{
	import qnx.fuse.ui.core.UIComponent;
	import qnx.fuse.ui.navigation.BasePane;
	import qnx.fuse.ui.navigation.TabbedPane;

	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.SoftKeyboardEvent;

	/**
	 * The <code>Application</code> class is the root class for all applications. 
	 * <p>Your main document class should exten this class. 
	 * This class is responsible for setting the main scene of your applicaiton and managing the z order of certain elements of the application.
	 * Not using this class can potentially cause issues with certain parts of the application.</p>
	 */
	public class Application extends UIComponent
	{
	
		
		static private var __instance:Application;
		
		/**
		* Gets a single instance of the class. 
		**/
		static public function get application():Application
		{
			return( __instance );
		}
				
		/**
		* Gets or sets the scene of the application.
		* <p>
		* The scene of the application is the class that handles navigation in your application. 
		* <code>TabbedPane</code> and <code>NavigationPane</code> are two classes that help with dealing with navigation.
		* If you wish to handle navigation on your own, you can set your scene to any <code>BasePane</code> subclass.
		* </p>
		* 
		* <p>
		* When a <code>TabbedPane</code> is set as the scene, its <code>tabOverflowParent</code> property is automatically set. 
		* This property should not be set when using a <code>TabbedPane</code> as your scene.
		* </p>
		**/
		public function get scene():BasePane
		{
			return( __scene );
		}
		
		public function set scene( value:BasePane ):void
		{
			if( __scene != value )
			{
				if( __scene )
				{
					if( __scene is TabbedPane )
					{
						TabbedPane( __scene ).tabOverflowParent = null;
					}
					
					
					if( contains( __scene ) )
					{
						removeChild( __scene );
					}
				}
				
				if( value is TabbedPane )
				{
					if( __taboverflow == null )
					{
						__taboverflow = new Sprite();
						addChildAt(__taboverflow, 0);
					}
					TabbedPane( value ).tabOverflowParent = __taboverflow;
				}
				
				
				__scene = value;
				addChild( __scene );
				invalidateDisplayList();
			}
		}
		
		private var __scene:BasePane;
		private var __taboverflow:Sprite;
		
		/**
		* Creates a <code>Application</code> instance.
		**/
		public function Application()
		{
			if( __instance == null )
			{
				__instance = this;
			}
			super();
		}
		
		/** @private **/
		override protected function init():void
		{
			var appDescriptor:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = appDescriptor.namespace();
			var skb:String = appDescriptor.ns::initialWindow.ns::softKeyboardBehavior;
			
			if( skb && skb == "none" )
			{
				initSoftKeyboard();
			}
			
			super.init();
		}

		private function initSoftKeyboard():void
		{
			stage.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, onKeyboardActivate );
			stage.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, onKeyboardDeactivate );
		}

		private function onKeyboardDeactivate( event:SoftKeyboardEvent ):void
		{
			scene.softKeyboardDeactivated();
		}

		private function onKeyboardActivate( event:SoftKeyboardEvent ):void
		{
			scene.softKeyboardActivated();
		}
		
		/** @private **/
		override protected function onAdded():void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener( Event.RESIZE, stageResize );
			super.onAdded();
		}

		private function stageResize( event:Event ):void
		{
			layout();
		}
		
		private function layout():void
		{
			if( __scene )
			{
				__scene.width = stage.stageWidth;
				__scene.height = stage.stageHeight;
			}
		}
		
		/** @private **/
		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
		{
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			layout();
		}
	}
}
