package org.apache.commons.scxml.model.nodes
{
	import org.apache.commons.scxml.abstract.GenericState;
	import org.apache.commons.scxml.model.Compiler;
	import org.apache.commons.scxml.model.SCXMLDocument;
	
	public interface ElementContent
	{
		function compile(node : XML,parentState : GenericState,doc : SCXMLDocument,compiler:Compiler,i:int):void;
	}
}