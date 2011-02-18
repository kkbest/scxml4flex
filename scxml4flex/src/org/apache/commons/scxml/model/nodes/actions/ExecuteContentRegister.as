package org.apache.commons.scxml.model.nodes.actions
{
	import org.apache.commons.scxml.datastructures.CustomActionClassMap;

	public class ExecuteContentRegister
	{
		public static var executeContentList:Array=new Array();
		
		executeContentList.push(new CustomActionClassMap("log","org.apache.commons.scxml.model.nodes.actions.LogAction"));
		executeContentList.push(new CustomActionClassMap("assign","org.apache.commons.scxml.model.nodes.actions.Assign"));
		executeContentList.push(new CustomActionClassMap("raise","org.apache.commons.scxml.model.nodes.actions.Raise"));
		executeContentList.push(new CustomActionClassMap("script","org.apache.commons.scxml.model.nodes.actions.Script"));
		executeContentList.push(new CustomActionClassMap("cancel","org.apache.commons.scxml.model.nodes.actions.Cancel"));
		executeContentList.push(new CustomActionClassMap("send","org.apache.commons.scxml.model.nodes.actions.Send"));
		executeContentList.push(new CustomActionClassMap("if","org.apache.commons.scxml.model.nodes.actions.If"));
		
		private var log:LogAction = null;
		private var assign:Assign = null;
		private var raise:Raise = null;
		private var script:Script = null;
		private var cancel:Cancel = null;
		private var send:Send = null;
		private var ife:If = null;
		public function ExecuteContentRegister()
		{
			
		}
	}
}