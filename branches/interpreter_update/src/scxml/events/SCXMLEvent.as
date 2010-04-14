package scxml.events {
	import flash.events.Event;
	
	import scxml.nodes.Transition;

	public class SCXMLEvent extends Event {
		public static var FINAL_STATE_REACHED : String = "finalStateReached";
		public static var START : String = "start";
		public static var STATE_ENTERED : String = "stateEntered";
		
		private var state : String;
		private var trans : Transition;
		
		public function SCXMLEvent(type:String, stateId : String = null, transition : Transition = null, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			state = stateId;
			trans = transition;
		}
		public function get stateId() : String {
			return state;
		}
		public function get transition() : Transition {
			return trans;
		}
	}
}