package
{
	import org.apache.commons.scxml.model.nodes.actions.ExecuteContent;
	import org.apache.commons.scxml.model.SCXMLDocument;
	import org.apache.commons.scxml.interfaces.IInterpreter;
	
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