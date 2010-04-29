package scxml.events {
	import flash.events.Event;
	
	public class InvokeEvent extends Event {
		
		public static var INIT : String = "init";
		public static var SEND_RESULT : String = "send_result";
		public static var CANCEL : String = "cancel";
		public static var ABORT : String = "abort";
		
		
		public var data : Object;
		
		public function InvokeEvent(type:String, data : Object = null, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			if(data)
				this.data = data;
		}
	}
}