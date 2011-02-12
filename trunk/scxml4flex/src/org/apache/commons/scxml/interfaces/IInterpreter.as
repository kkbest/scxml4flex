package org.apache.commons.scxml.interfaces {
	import org.apache.commons.scxml.datastructures.Queue;
	
	import flash.events.IEventDispatcher;
	
	import mx.core.IStateClient;
	
	import org.apache.commons.scxml.model.SCXMLDocument;

	public interface IInterpreter extends IEventDispatcher {
		
		function send(eventName : Object, sendId : String = null, delay : Number = 0, data : Object = null, invokeid : String = null, toQueue : Queue = null) : void;
		function raiseFunction(eventName : Array) : void;
		
		function cancelEvent(sendId : String) : void;
		
		function interpret(document : SCXMLDocument, optionalParentExternalQueue : Queue = null, invokeId : String = null) : void;
		function isFinished() : Boolean;
		function set root(container : IStateClient) : void;
		function get invokeid() : String;
		function get dataModel() : Object;
	}
}