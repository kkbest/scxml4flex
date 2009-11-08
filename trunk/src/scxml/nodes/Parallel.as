package scxml.nodes {
	import abstract.GenericState;
	
	import interfaces.IState;
	
	public class Parallel extends GenericState {
		public function Parallel(sId : String, pState : IState, num : Number = NaN) {
			super(sId, pState, num);
			optionalProperties = ["src", "initial"];
		}
		
		public function toString() : String {
			var parentId : String = parent ? parent.id : null;
			var output : String = "";
			output += "State id='" + sId + "' parent='" + parentId + "'\n";
			for each (var t : Transition in transition) {
				output += "\t" + t.toString() + "\n";
			}
			 
			return output;
		}
	}
}