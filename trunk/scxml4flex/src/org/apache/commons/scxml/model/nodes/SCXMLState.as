package org.apache.commons.scxml.model.nodes {
	import org.apache.commons.scxml.abstract.GenericState;
	import org.apache.commons.scxml.interfaces.IState;
	import org.apache.commons.scxml.model.SCXMLDocument;
	import org.apache.commons.scxml.model.Compiler;
	
	public class SCXMLState extends GenericState implements ElementContent{
		
		private var flexViewState : String;
		
		public function SCXMLState(sId : String = "", pState : IState = null, num : Number = NaN) { 
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
		
		private function isCompoundState(node : XML) : Boolean {
			return node.hasOwnProperty("state") || node.hasOwnProperty("parallel") || node.hasOwnProperty("final");
		}

		public function compile(node:XML, parentState:GenericState, doc:SCXMLDocument, compiler:Compiler, i:int):void{
			var newState : SCXMLState = doc.pushState(new SCXMLState(compiler.get_sid(node), parentState, i)) as SCXMLState;
			if(node.hasOwnProperty("@viewstate"))
				newState.viewstate = String(node.@viewstate);
			if(isCompoundState(node))
				newState.initial = compiler.parseInitial(node);
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