package scxml.events {
	import flash.events.Event;
	
	public class InvokeEvent extends Event {
		
		public static var INIT : String = "init";
		public static var RESULT : String = "result";
		
		public var data : Object;
		
		public function InvokeEvent(type:String, data : Object = null, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			if(data)
				this.data = data;
		}
	}
}