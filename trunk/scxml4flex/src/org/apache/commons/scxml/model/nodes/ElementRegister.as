package org.apache.commons.scxml.model.nodes
{
	import org.apache.commons.scxml.datastructures.CustomActionClassMap;
	import org.apache.commons.scxml.model.invoke.InvokeSCXML;
	
	public class ElementRegister
	{
		public var elementsList:Array=new Array();
		public function ElementRegister()
		{
			elementsList.push(new CustomActionClassMap("state","org.apache.commons.scxml.model.nodes.SCXMLState"));
			elementsList.push(new CustomActionClassMap("transition","org.apache.commons.scxml.model.nodes.Transition"));
			elementsList.push(new CustomActionClassMap("final","org.apache.commons.scxml.model.nodes.Final"));
			elementsList.push(new CustomActionClassMap("history","org.apache.commons.scxml.model.nodes.History"));
			elementsList.push(new CustomActionClassMap("parallel","org.apache.commons.scxml.model.nodes.Parallel"));
			elementsList.push(new CustomActionClassMap("onentry","org.apache.commons.scxml.model.nodes.OnEntry"));
			elementsList.push(new CustomActionClassMap("onexit","org.apache.commons.scxml.model.nodes.OnExit"));
			elementsList.push(new CustomActionClassMap("data","org.apache.commons.scxml.model.nodes.Data"));
			elementsList.push(new CustomActionClassMap("invoke","org.apache.commons.scxml.model.invoke.InvokeSCXML"));
			
			var state:SCXMLState = null;
			var transition:Transition = null;
			var final:Final = null;
			var history:History = null;
			var parallel:Parallel = null;
			var onentry:OnEntry = null;
			var onexit:OnExit = null;
			var data:Data = null;
			var invoke:InvokeSCXML = null;
		}
	}
}