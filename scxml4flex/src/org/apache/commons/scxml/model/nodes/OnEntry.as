package org.apache.commons.scxml.model.nodes
{
	import org.apache.commons.scxml.abstract.GenericState;
	import org.apache.commons.scxml.model.SCXMLDocument;
	import org.apache.commons.scxml.model.Compiler;
	
	public class OnEntry implements ElementContent
	{
		public function OnEntry()
		{
		}
		
		public function compile(node:XML, parentState:GenericState, doc:SCXMLDocument, compiler:Compiler, i:int):void{
			var onEntry : Exec = new Exec(compiler.makeExecContent(node));
			parentState.addOnEntry(onEntry);
		}
	}
}