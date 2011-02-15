package org.apache.commons.scxml.model.nodes.actions
{
	import org.apache.commons.scxml.datastructures.CustomActionClassMap;

	public class ExecuteContentRegister
	{
		public var executeContentList:Array=new Array();
		public function ExecuteContentRegister()
		{
			executeContentList.push(new CustomActionClassMap("log","org.apache.commons.scxml.model.nodes.actions.LogAction"));
			executeContentList.push(new CustomActionClassMap("assign","org.apache.commons.scxml.model.nodes.actions.Assign"));
			executeContentList.push(new CustomActionClassMap("raise","org.apache.commons.scxml.model.nodes.actions.Raise"));
			executeContentList.push(new CustomActionClassMap("script","org.apache.commons.scxml.model.nodes.actions.Script"));
			executeContentList.push(new CustomActionClassMap("cancel","org.apache.commons.scxml.model.nodes.actions.Cancel"));
			executeContentList.push(new CustomActionClassMap("send","org.apache.commons.scxml.model.nodes.actions.Send"));
			
			var log:LogAction = null;
			var assign:Assign = null;
			var raise:Raise = null;
			var script:Script = null;
			var cancel:Cancel = null;
			var send:Send = null;
		}
	}
}