package org.apache.commons.scxml.model.nodes
{
	import org.apache.commons.scxml.abstract.GenericState;
	import org.apache.commons.scxml.model.SCXMLDocument;
	import org.apache.commons.scxml.model.Compiler;
	
	public class OnExit implements ElementContent
	{
		public function OnExit()
		{
		}
		
		public function compile(node:XML, parentState:GenericState, doc:SCXMLDocument, compiler:Compiler, i:int):void{
			var onExit : Exec = new Exec(compiler.makeExecContent(node));
			parentState.addOnExit(onExit);
		}
	}
}