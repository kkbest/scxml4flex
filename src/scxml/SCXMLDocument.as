package scxml {
	import abstract.GenericState;
	
	import scxml.nodes.*;
	
	public class SCXMLDocument {
		public var states : Object;
		public var dataModel : Object;
		private var rootState : MainState;
		
		public function SCXMLDocument()	{
			states = {};
			dataModel = {"set" : function(key : String, val : *) : void {this.dataModel[key] = val;}};
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
			states[s.id] = s;
			rootState = s;
		}
		public function get mainState() : MainState {
			return MainState(getState("__main__"));
		}
		public function toString() : String {
			return "SCXMLDocument";
		}
	}
}