package org.apache.commons.scxml.model.nodes
{
	import org.apache.commons.scxml.abstract.GenericState;
	import org.apache.commons.scxml.model.SCXMLDocument;
	import org.apache.commons.scxml.model.Compiler;
	
	public class Data implements ElementContent
	{
		public function Data()
		{
		}
		
		public function compile(node:XML, parentState:GenericState, doc:SCXMLDocument, compiler:Compiler, i:int):void{
			if(node.hasOwnProperty("@expr"))
				doc.dataModel[String(node.@id)] = compiler.evalExpr(node.@expr);
			else
				doc.dataModel[String(node.@id)] = node.toString();
		}
	}
}