package interfaces {
	import datastructures.Queue;
	
	import flash.events.IEventDispatcher;
	
	import mx.core.IStateClient;
	
	import scxml.SCXMLDocument;

	public interface IInterpreter extends IEventDispatcher {
		
		function send(eventName : Object, sendId : String = null, delay : Number = 0, data : Object = null) : void;
		function raiseFunction(eventName : Array) : void;
		
		function cancelEvent(sendId : String) : void;
		
		function interpret(document : SCXMLDocument, optionalParentExternalQueue : Queue = null, invokeId : String = null) : void;
		function isFinished() : Boolean;
		function set root(container : IStateClient) : void;
	}
}