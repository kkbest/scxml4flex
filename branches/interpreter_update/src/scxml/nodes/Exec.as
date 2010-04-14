package scxml.nodes
{
	import interfaces.IExecutable;

	public class Exec implements IExecutable {
		
		private var functions : Array;
		
		public function Exec(f : Array) {
			functions = f;
		}
		
		public function executeContent(scope : Object, dataModel : Object) : void {
			for each(var f : Function in functions) {
				f(scope, dataModel);
			}
		}
		
	}
}