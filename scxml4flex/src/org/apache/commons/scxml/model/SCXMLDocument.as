package org.apache.commons.scxml.model {
	import org.apache.commons.scxml.abstract.GenericState;
	import org.apache.commons.scxml.model.nodes.*;
	import org.apache.commons.scxml.xpath.StandardFunctions;
	
	public class SCXMLDocument {
		public var states : Object;
		public var dataModel : Object = new Object();
		private var rootState : MainState;
		internal static var defaultFunctions:Object = new StandardFunctions();
		
		public function SCXMLDocument()	{
			states = {};
			dataModel["set"]=function(key : String, val : *) : void {this.dataModel[key] = val;};
			dataModel["compare"]=defaultFunctions["compare"] as Function;
			dataModel["codepoint_equal"]=defaultFunctions["codepoint-equal"] as Function;
			dataModel["concat"]=defaultFunctions["concat"] as Function;
			dataModel["string_join"]=defaultFunctions["string-join"] as Function;
			dataModel["contains"]=defaultFunctions["contains"] as Function;
			dataModel["starts_with"]=defaultFunctions["starts-with"] as Function;
			dataModel["ends_with"]=defaultFunctions["ends-with"] as Function;
			dataModel["substring_before"]=defaultFunctions["substring_before"] as Function;
			dataModel["substring_after"]=defaultFunctions["substring_after"] as Function;
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