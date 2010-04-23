package scxml {
	import datastructures.Queue;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import interfaces.IInterpreter;
	
	import mx.core.IStateClient;
	
	import scxml.events.SCXMLEvent;
	
	[Event(name="finalStateReached", type="scxml.events.SCXMLEvent")]
	[Event(name="start", type="scxml.events.SCXMLEvent")]
//	[Event(name="stateEntered", type="scxml.events.SCXMLEvent")]
	
	[DefaultProperty("source")]
	
	public class SCXML extends EventDispatcher {
		
		private var compiler : Compiler;
		private var interpreter : IInterpreter;
		
		public function SCXML() {
			super();
			interpreter = new Interpreter();
			interpreter.addEventListener(SCXMLEvent.FINAL_STATE_REACHED, onFinalStateReached);
		}
		
		public function set source(xml : XML) : void {
			if(xml is String) { //TODO: make this work.
			}
			compiler = new Compiler(interpreter);  
			
			compiler.parse(xml);
		}
		public function start(optionalParentExternalQueue : Queue = null, invokeId : String = null) : void {
			interpreter.interpret(compiler.document, optionalParentExternalQueue, invokeId);
			dispatchEvent(new SCXMLEvent(SCXMLEvent.START));
		}
//		public function get currentState() : String {
//			var config : Array = configuration.toList();
//			return config[config.length-1]["id"];
//		}
		
		public function send(eventName : Object, sendId : String = null, delay : Number = 0, data : Object = null, invokeid : String = null, toQueue : Queue = null) : void {
			interpreter.send(eventName, sendId, delay, data, invokeid, toQueue);
		}
		
		public function set root(container : IStateClient) : void {
			interpreter.root = container;
		} 
		
		public function isFinished() : Boolean {
 			return interpreter.isFinished();
		}
		private function onFinalStateReached(event : SCXMLEvent) : void {
			dispatchEvent(new SCXMLEvent(SCXMLEvent.FINAL_STATE_REACHED));
		}
	}
}