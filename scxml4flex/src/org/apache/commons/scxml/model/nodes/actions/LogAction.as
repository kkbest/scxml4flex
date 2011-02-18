package org.apache.commons.scxml.model.nodes.actions
{
	import org.apache.commons.scxml.interfaces.IInterpreter;
	import org.apache.commons.scxml.model.SCXMLDocument;
	
	/**
	 * The class in this SCXML object model that corresponds to the
	 * <log> SCXML element.
	 *
	 */
	
	public class LogAction implements ExecuteContent
	{
		public function execute(child : XML,doc : SCXMLDocument,interpreter : IInterpreter):Function{
			var label : String = child.hasOwnProperty("@label") ? child.@label + ": " : "Log: ";
			var f : Function = function() : void {
				//trace(label + D.eval(child.@expr, doc.dataModel));
				trace(label + doc.dataModel[child.@expr]);
			};
			return f;
		}
	}
}