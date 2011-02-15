package org.apache.commons.scxml.model.nodes.actions
{
	import r1.deval.D;
	import org.apache.commons.scxml.model.SCXMLDocument;
	import org.apache.commons.scxml.interfaces.IInterpreter;
	
	/**
	 * The class in this SCXML object model that corresponds to the
	 * <cancel> SCXML element.
	 *
	 */
	
	public class Cancel implements ExecuteContent
	{
		public function Cancel()
		{
		}
		
		public function execute(child : XML,doc : SCXMLDocument,interpreter : IInterpreter):Function{
			var f : Function = function() : void {interpreter.cancelEvent(child.@sendid)};
			return f;
		}
	}
}