package org.apache.commons.scxml.model.nodes.actions
{
	import org.apache.commons.scxml.model.SCXMLDocument;
	import org.apache.commons.scxml.interfaces.IInterpreter;
	
	public interface ExecuteContent
	{
		function execute(child : XML,doc : SCXMLDocument,interpreter : IInterpreter):Function;
	}
}