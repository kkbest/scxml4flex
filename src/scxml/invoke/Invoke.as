package scxml.invoke {
	import datastructures.Queue;
	
	import flash.events.EventDispatcher;
	
	import scxml.events.InvokeEvent;

	public class Invoke extends EventDispatcher {
		
		private var _invokeid : String;
		private var _type : String;
		
		protected var _lastResult : Object;
		private var _finalizeArray : Array;
		
		
		public function send(eventName : Object, sendId : String = null, delay : Number = 0, data : Object = null, toQueue : Queue = null) : void {
		}
		
		public function start(optionalParentExternalQueue : Queue = null, invokeId : String = null) : void {
			dispatchEvent(new InvokeEvent(InvokeEvent.INIT));
		}
		
		public function cancel() : void {
			dispatchEvent(new InvokeEvent(InvokeEvent.CANCEL));
		}
		
		public function get invokeid():String
		{
			return _invokeid;
		}
		
		public function set invokeid(value:String):void
		{
			_invokeid = value;
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function set type(value:String):void
		{
			_type = value;
		}
		
		public function get lastResult():Object
		{
			return _lastResult;
		}
		
		public function finalize(): void
		{
			for each(var func : Function in _finalizeArray)
				func();
		}
		
		public function set finalizeArray(value:Array):void
		{
			_finalizeArray = value;
		}
		
	}
}