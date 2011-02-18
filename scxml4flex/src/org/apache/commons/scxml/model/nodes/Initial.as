package org.apache.commons.scxml.model.nodes {
	import org.apache.commons.scxml.interfaces.IExecutable;

	dynamic public class Initial extends Array implements IExecutable {
		
		private var functions : Array;
		
		public function Initial(startArray : Array) {
			super();
			for each(var elem : * in startArray)
				push(elem);
			functions = [];
		}
		
		public function setExecFunctions(array : Array) : void {
			functions = array;
		}
		
		public function executeContent() : void {
			for each(var f : Function in functions)
				f();
		}
	}
}