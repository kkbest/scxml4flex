package org.apache.commons.scxml.model.nodes {
	import org.apache.commons.scxml.abstract.GenericState;
	
	import org.apache.commons.scxml.interfaces.IState;
	import org.apache.commons.scxml.model.SCXMLDocument;
	import org.apache.commons.scxml.model.Compiler;
	
	public class Parallel extends GenericState implements ElementContent{
		public function Parallel(sId : String="", pState : IState=null, num : Number = NaN) {
			super(sId, pState, num);
		}
		
		public function compile(node:XML, parentState:GenericState, doc:SCXMLDocument, compiler:Compiler, i:int):void{
			var parallelState : GenericState = doc.pushState(new Parallel(compiler.get_sid(node), parentState, i));
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