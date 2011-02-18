package org.apache.commons.scxml.model {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.core.IStateClient;
	
	import org.apache.commons.scxml.datastructures.Queue;
	import org.apache.commons.scxml.interfaces.IInterpreter;
	import org.apache.commons.scxml.model.events.SCXMLEvent;
	
	[Event(name="finalStateReached", type="org.apache.commons.scxml.model.events.SCXMLEvent")]
	[Event(name="start", type="org.apache.commons.scxml.model.events.SCXMLEvent")]
	[Event(name="stateEntered", type="org.apache.commons.scxml.model.events.SCXMLEvent")]
	
	[DefaultProperty("source")]
	
	public class SCXML extends EventDispatcher {
		
		private var compiler : Compiler;
		private var interpreter : IInterpreter;
		private var _source : XML;
		private var customActionList:Array = null;
		
		public function SCXML() {
			interpreter = new Interpreter();
			interpreter.addEventListener(SCXMLEvent.FINAL_STATE_REACHED, onFinalStateReached);
			interpreter.addEventListener(SCXMLEvent.STATE_ENTERED, onStateEntered);
		}
		
		public function addCustomAction(caList:Array):void{
			customActionList=caList;
		}
		
		public function set source(xml : XML) : void {
			trace("source", xml);
			_source = xml;
			compiler = new Compiler(interpreter);
			if(customActionList!=null) compiler.setCustomAction(customActionList);
			
			compiler.parse(xml);
		}
		public function get source() : XML {
			return _source;
		}
		public function start(optionalParentExternalQueue : Queue = null, invokeId : String = null) : void {
			interpreter.interpret(compiler.document, optionalParentExternalQueue, invokeId);
			dispatchEvent(new SCXMLEvent(SCXMLEvent.START));
		}
		
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
		private function onStateEntered(event : SCXMLEvent) : void {
			dispatchEvent(new SCXMLEvent(SCXMLEvent.STATE_ENTERED, event.stateId, event.transition));
//			dispatchEvent(event);
		}
		
		public function get dataModel() : Object {
			return interpreter.dataModel;
		}
	}
}