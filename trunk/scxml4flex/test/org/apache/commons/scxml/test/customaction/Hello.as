package org.apache.commons.scxml.test.customaction
{
	import org.apache.commons.scxml.interfaces.IInterpreter;
	import org.apache.commons.scxml.model.SCXMLDocument;
	import org.apache.commons.scxml.model.nodes.actions.ExecuteContent;
	
	public class Hello implements ExecuteContent
	{
		public function Hello()
		{
		}
		
		public function execute(child : XML,doc : SCXMLDocument,interpreter : IInterpreter):Function{
			var label : String = child.hasOwnProperty("@name") ? child.@name + ": " : "Name property of Hello element: ";
			var f : Function = function() : void {
				trace("------CustomAction execute method:----------"+label);
			};
			return f;
		}
	}
}