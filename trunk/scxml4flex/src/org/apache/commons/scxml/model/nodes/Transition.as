package org.apache.commons.scxml.model.nodes {
	import org.apache.commons.scxml.abstract.GenericState;
	
	import org.apache.commons.scxml.interfaces.IExecutable;
	
	import org.apache.commons.scxml.util.ArrayUtils;
	import org.apache.commons.scxml.model.SCXMLDocument;
	import org.apache.commons.scxml.model.Compiler;
	
	public class Transition implements IExecutable,ElementContent {
		
		private var sourceState : GenericState;
		private var targetArray : Array;
		public var cond : Function;
		public var event : Array;
		private var functions : Array;
		
		public function Transition(source : GenericState=null) {
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
		
		public function parseTransition(node : XML, source : GenericState, compiler:Compiler) : Transition {
			var t : Transition = new Transition(source);
			t.setExecFunctions(compiler.makeExecContent(node));
			
			if(node.hasOwnProperty("@cond"))
				t.cond = compiler.getExprFunction(node.@cond);
			if(node.hasOwnProperty("@target"))
				t.target = String(node.@target).split(" ");
			if(node.hasOwnProperty("@event"))
				t.event = ArrayUtils.map(function(x : String) : Array {return x.replace(/(.*)\.\*$/, "$1").split(".")}, node.@event.split(" ")); 
			
			return t;
		}
		
		public function compile(node:XML, parentState:GenericState, doc:SCXMLDocument, compiler:Compiler, i:int):void{
			if(String(node.parent().localName()) != "initial") {
				var transition : Transition = parseTransition(node, parentState, compiler);
				parentState.addTransition(transition);
			} 
		}
		
		public function toString() : String {
			if(source) var sourceId : String = source.id;
			return "Transition source='" + sourceId + "' target='" + target + "' hasCond='" + Boolean(cond) + "' hasExe='" + Boolean(functions) + "'";
		}

	}
}