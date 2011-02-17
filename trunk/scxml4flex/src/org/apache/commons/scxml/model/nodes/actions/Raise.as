package org.apache.commons.scxml.model.nodes.actions
{
	import org.apache.commons.scxml.interfaces.IInterpreter;
	import org.apache.commons.scxml.model.SCXMLDocument;
	
	/**
	 * The class in this SCXML object model that corresponds to the
	 * <raise> SCXML element.
	 *
	 */
	
	public class Raise implements ExecuteContent
	{
		public function Raise()
		{
		}
		
		public function execute(child : XML,doc : SCXMLDocument,interpreter : IInterpreter):Function{
			var f : Function = function() : void {interpreter.raiseFunction(child.@event.split("."))};
			return f;
		}
	}
}