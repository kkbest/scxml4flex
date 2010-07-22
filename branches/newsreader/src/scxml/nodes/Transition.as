package scxml.nodes {
	import abstract.GenericState;
	
	import interfaces.IExecutable;
	
	import util.ArrayUtils;
	
	public class Transition implements IExecutable {
		
		private var sourceState : GenericState;
		private var targetArray : Array;
		public var cond : Function;
		public var event : Array;
		private var functions : Array;
		
		public function Transition(source : GenericState) {
			sourceState = source;
			
		}
		
		public function get source() : GenericState {
			return sourceState;
		}
		public function get target() : Array {
			return targetArray;
		}
		public function set target(a : Array) : void {
			targetArray = a;
		}
		
		public function setExecFunctions(array : Array) : void {
			functions = array;
		}
		public function executeContent() : void {
			for each(var f : Function in functions)
				f();
		}
		
		public function toString() : String {
			if(source) var sourceId : String = source.id;
			return "Transition source='" + sourceId + "' target='" + target + "' hasCond='" + Boolean(cond) + "' hasExe='" + Boolean(functions) + "'";
		}

	}
}