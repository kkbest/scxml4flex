package org.apache.commons.scxml.model.nodes {
	import org.apache.commons.scxml.abstract.GenericState;
	
	import org.apache.commons.scxml.interfaces.IState;
	
	import org.apache.commons.scxml.model.error.SCXMLValidationError;
	import org.apache.commons.scxml.model.SCXMLDocument;
	import org.apache.commons.scxml.model.Compiler;
	
	public class Final extends GenericState implements ElementContent{
		
		public function Final(sId : String="", pState : IState=null, num : Number = NaN) {
			super(sId, pState, num);
		}
		
		override public function set initial(s : Initial) : void {
			throw new SCXMLValidationError("Inital tag not allowed as child of Final");
		} 
		override public function get initial() : Initial {
			return new Initial([]);
		}
		
		override public function get transition() : Array {
			return [];
		}
		override public function get history() : Array {
			return [];
		}
		
		public function compile(node:XML, parentState:GenericState, doc:SCXMLDocument, compiler:Compiler, i:int):void{
			doc.pushState(new Final(compiler.get_sid(node), parentState, i));
		}
	}
}