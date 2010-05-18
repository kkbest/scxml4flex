package scxml.invoke {
	import datastructures.Queue;
	
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	
	import scxml.events.InvokeEvent;

	public class Invoke extends EventDispatcher {
		
		private var _invokeid : String;
		private var _type : String;
		private var _finalizeArray : Array;
		private var _autoforward : Boolean = false;
		
		protected var _lastResult : Object;
		protected var _isReady : Boolean = false;
		
		public function Invoke() {
		}
		
		public function send(eventName : Object, sendId : String = null, delay : Number = 0, data : Object = null, toQueue : Queue = null) : void {
			throw new IllegalOperationError("Method must be overwritten");
		}
		
		public function start(optionalParentExternalQueue : Queue = null, invokeId : String = null) : void {
			dispatchEvent(new InvokeEvent(InvokeEvent.INIT));
			_isReady = true;
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
		
		public function get autoforward():Boolean
		{
			return _autoforward;
		}
		
		public function set autoforward(value:Boolean):void
		{
			_autoforward = value;
		}
		
		public function get isReady():Boolean
		{
			return _isReady;
		}
	}
}