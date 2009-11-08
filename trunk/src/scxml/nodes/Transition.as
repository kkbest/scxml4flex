package scxml.nodes {
	import abstract.GenericState;
	import abstract.SCXMLNode;
	
	import interfaces.IExecutable;
	
	public class Transition extends SCXMLNode implements IExecutable {
		
		private var sourceState : GenericState;
		private var targetArray : Array;
		public var cond : Function;
		public var event : String;
		private var functions : Array;
		
		public function Transition(source : GenericState) {
			sourceState = source;
			optionalProperties = ["event", "target", "anchor"];
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
		
		override public function setProperties(node : XML) : void {
			
			for each(var p : String in optionalProperties)
				if(node.hasOwnProperty("@" + p))
					if(p == "target")
						this[p] = String(node.@[p]).split(" ");
					else
						this[p] = String(node.@[p]);
		}
		
		public function setExecFunctions(array : Array) : void {
			functions = array;
		}
		public function executeContent(scope : Object, dataModel : Object) : void {
			for each(var f : Function in functions)
				f(scope, dataModel);
		}
		
		public function toString() : String {
			if(source) var sourceId : String = source.id;
			return "Transition source='" + sourceId + "' target='" + target + "' hasCond='" + Boolean(cond) + "' hasExe='" + Boolean(functions) + "'";
		}

	}
}