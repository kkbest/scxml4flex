package scxml {
	import abstract.GenericState;
	
	import scxml.nodes.*;
	
	public class SCXMLDocument {
		public var states : Object;
		public var dataModel : Object;
		private var rootState : MainState;
		
		public function SCXMLDocument()	{
			states = {};
			dataModel = {};
			states["root"] = new SCXMLState("root", null);
		}
		public function pushState(s : GenericState) : GenericState {
			states[s.id] = s;
			GenericState(s.parent).addState(s);
			return s;
		}
		public function pushHistory(h : History) : History {
			states[h.id] = h;
			GenericState(h.parent).addHistory(h);
			return h;
		}
		public function pushTransition(t : Transition) : void {
			states[t.source.id].addTransition(t);
		}
		public function getState(id : String) : GenericState {
			return states[id];
		}
		public function asArray() : Array {
			var output : Array = [];
			for each(var key : SCXMLState in states) {
				output.push(key);
			}
			return output;
		}
		public function set mainState(s : MainState) : void {
			rootState = s;
		}
		public function get mainState() : MainState {
			return rootState;
		}
		public function toString() : String {
			return "SCXMLDocument";
		}
	}
}