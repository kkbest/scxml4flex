package org.apache.commons.scxml.model.nodes {
	import org.apache.commons.scxml.abstract.GenericState;
	
	import org.apache.commons.scxml.interfaces.IState;
	
	public class SCXMLState extends GenericState {
		
		private var flexViewState : String;
		
		public function SCXMLState(sId : String, pState : IState, num : Number = NaN) { 
			super(sId, pState, num); 
		}
		
		public function set viewstate(id : String) : void {
			if(id == "base")
				id = "";
			flexViewState = id;
		}
		override public function get viewstate() : String {
			return flexViewState;
		}
		
		override public function get initial():Initial {
			if(!super.initial.length > 0) 
				initial = new Initial([this.stateArray[0].id]);
			return super.initial;
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