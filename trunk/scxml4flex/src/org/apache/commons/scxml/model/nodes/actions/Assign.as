package org.apache.commons.scxml.model.nodes.actions
{
	import org.apache.commons.scxml.interfaces.IInterpreter;
	import org.apache.commons.scxml.model.SCXMLDocument;
	
	import r1.deval.D;
	
	/**
	 * The class in this SCXML object model that corresponds to the
	 * <assign> SCXML element.
	 *
	 */
	
	public class Assign implements ExecuteContent
	{
		public function Assign()
		{
		}
		
		public function execute(child : XML,doc : SCXMLDocument,interpreter : IInterpreter):Function{
			var f : Function = function() : void {
				var expression : String = child.hasOwnProperty("@expr") ? child.@expr : child.text.toString();
				doc.dataModel[String(child.@location)] = D.eval(expression, doc.dataModel);
			};
			return f;
		}
	}
}