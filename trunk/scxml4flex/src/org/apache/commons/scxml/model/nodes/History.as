package org.apache.commons.scxml.model.nodes {
	import org.apache.commons.scxml.abstract.GenericState;
	
	import org.apache.commons.scxml.interfaces.IState;
	import org.apache.commons.scxml.model.SCXMLDocument;
	import org.apache.commons.scxml.model.Compiler;
	
	public class History extends GenericState implements ElementContent{
		public static var TYPE_DEEP : String = "deep";
		public static var TYPE_SHALLOW : String = "shallow";
		
		private var _type : String = "shallow";
		
		public function History(sId : String="", pState : IState=null, num : Number = NaN) { 
			super(sId, pState, num);
		}
		public function get type() : String {
			return _type;
		}
		public function set type(s : String) : void {
			if(!s || s == "") return;
			_type = s;
			if(_type != TYPE_SHALLOW || _type != TYPE_DEEP) 
				throw new Error("History type must equal 'deep' or 'shallow'");
		}
		
		public function compile(node:XML, parentState:GenericState, doc:SCXMLDocument, compiler:Compiler, i:int):void{
			var history : History = doc.pushHistory(new History(compiler.get_sid(node), parentState, i));
			history.type = node.@type;
		}
	}
}