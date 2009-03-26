package org.goverla.events
{
	import flash.events.Event;

	public class HeaderRendererEvent extends Event
	{
		public static var GROUP_HEADER_EXPANDED_CHANGE : String = "groupHeaderExpandedChange";
		
		public static var HEADER_CLOSED : String = "headerClosed";
		
		public var data : Object;
		
		public function HeaderRendererEvent(type : String, bubbles : Boolean = false,
			cancelable : Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}