package org.apache.commons.scxml.model.nodes.actions
{
	public class ElseIf
	{	
		private var condCondition:Function;
		private var functionList:Array = new Array();
		public function ElseIf()
		{
		}
		
		public function set cond(c:Function):void{
			condCondition=c;
		}
		
		public function get cond():Function{
			return condCondition;
		}
		
		public function set funList(fList:Array):void{
			functionList=fList;
		}
		
		public function get funList():Array{
			return functionList;
		}
	}
}