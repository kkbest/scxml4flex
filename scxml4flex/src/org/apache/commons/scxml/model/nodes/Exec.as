package org.apache.commons.scxml.model.nodes
{
	import org.apache.commons.scxml.interfaces.IExecutable;

	public class Exec implements IExecutable {
		
		private var functions : Array;
		
		public function Exec(f : Array) {
			functions = f;
		}
		
		public function executeContent() : void {
			for each(var f : Function in functions) {
				f();
			}
		}
		
	}
}