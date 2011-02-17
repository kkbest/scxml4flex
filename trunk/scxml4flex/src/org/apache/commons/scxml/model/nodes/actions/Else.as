package org.apache.commons.scxml.model.nodes.actions
{
	public class Else
	{
		private var functionList:Array = new Array();
		
		public function Else()
		{
		}
		
		public function set funList(fList:Array):void{
			functionList=fList;
		}
		
		public function get funList():Array{
			return functionList;
		}
	}
}