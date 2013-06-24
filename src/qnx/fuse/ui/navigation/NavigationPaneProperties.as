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
	import qnx.fuse.ui.core.Action;
	/**
	 * A class to specify properties on a child pane of a <code>NavigationPane</code>.
	 * <p>
	 * Even if it's possible to specify a <code>NavigationPaneProperties</code> on any <code>BasePane</code>, it's ignored unless the parent is a <code>NavigationPane</code>.
	 * </p>
	 * <p>
	 * The <code>Action</code> class can be used to customize the appearance and/or behavior of the back button. 
	 * The image and title properties of the <code>Action</code> are shown on the back button. 
	 * </p>
	 * <p>
	 * When the back button is pressed, the page is automatically popped off the navigation stack.
	 * </p>
	 */
	public class NavigationPaneProperties extends PaneProperties
	{
		/**
		 * The back button for this <code>NavigationPaneProperties</code>.
		 * <p>
		 * If no back button is specified, the back button will get a default image and the displayed text will be used.
		 * </p>
		 */
		public var backButton:Action;
	}
}
