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
package qnx.fuse.ui.navigation {
	import qnx.fuse.ui.core.Action;

	/**
	 * A tab that can be added to a <code>TabbedPane</code>.
	 * <p>
	 * The <code>Tab</code> objects in the <code>TabbedPane</code> are added to the Action bar, 
	 * which is a horizontal bar displayed at the bottom of the screen. 
	 * By pressing the tabs on the Action bar the user can switch the content that is currently being displayed on the screen. 
	 * The <code>Tab</code> objects take an <code>BasePane</code> as their content.
	 * </p>
	 * <p>
	 * Even though a <code>Tab</code> takes <code>BasePane</code> as its content, not all classes deriving from <code>BasePane</code> are valid as the content. 
	 * The valid classes are <code>Page</code> and <code>NavigationPane</code>.
	 * </p>
	 */
	public class Tab extends Action 
	{
		/**
		 * An instnace of <code>BasePane</code> to display as the content.
		 * <p>
		 * It is recommended to use the <code>contentClass</code> argument in the constructor to define the content for the tab.
		 * Using this method instead will allow the <code>TabbedPane</code> to create the content on demand, which reduces memory and start up times.
		 * </p>
		 * <p>
		 * If the <code>content</code> property is not set, <code>TabbedPane</code> will create the content based on the <code>contentClass</code> property.
		 * It will then set the <code>content</code> property so it will not have to create it every time.
		 * </p>
		 * @see #contentClass
		 */
		public var content:BasePane;
		
		private var __contentClass:Class;
		
		/**
		 * The <code>Class</code> of the content for the <code>Tab</code>
		 * <p>
		 * If the <code>content</code> property is not set, <code>TabbedPane</code> will create the content based on the <code>contentClass</code> property.
		 * It will then set the <code>content</code> property so it will not have to create it every time.
		 * </p>
		 * @see content
		 */
		public function get contentClass():Class
		{
			return( __contentClass );
		}
		
		/**
		 * Creates a <code>Tab</code> instance.
		 * @param label The label of the tab.
		 * @param icon The icon of the tab.
		 * @param data The data of the tab.
		 * @param contentClass The content class of the tab.
		 * 
		 * @see #content
		 * @see #contentClass
		 */
		public function Tab( label : String, icon : Object = null, data : Object = null, contentClass:Class = null ) 
		{
			super( label, icon, data );
			__contentClass = contentClass;
		}
	}
}
