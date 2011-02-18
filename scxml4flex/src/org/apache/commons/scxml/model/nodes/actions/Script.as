package org.apache.commons.scxml.model.nodes.actions
{
	import org.apache.commons.scxml.interfaces.IInterpreter;
	import org.apache.commons.scxml.model.SCXMLDocument;
	
	import r1.deval.D;
	
	/**
	 * The class in this SCXML object model that corresponds to the
	 * <script> SCXML element.
	 *
	 */
	
	public class Script implements ExecuteContent
	{
		public function Script()
		{
		}
		
		public function execute(child : XML,doc : SCXMLDocument,interpreter : IInterpreter):Function{
			var code : String = child.toString();
			var f : Function = function() : void {
				D.eval(code, doc.dataModel)
			};
			return f;
		}
	}
}