package scxml.nodes {
	import abstract.GenericState;
	
	import interfaces.IState;
	
	public class SCXMLState extends GenericState {
		
		private var flexViewState : String;
//		private var initTransition : Transition;
		
		public function SCXMLState(sId : String, pState : IState, num : Number = NaN) { 
			super(sId, pState, num); 
			optionalProperties = ["src", "viewstate", "initial"];
		}
		
		public function set viewstate(id : String) : void {
			if(id == "base")
				id = "";
			flexViewState = id;
		}
		override public function get viewstate() : String {
			return flexViewState;
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