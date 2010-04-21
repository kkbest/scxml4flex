package scxml.invoke {
	import datastructures.Queue;

	public class Invoke {
		
		private var _invokeid : String;
		private var _type : String;
		
		public function send(eventName : Object, sendId : String = null, delay : Number = 0, data : Object = null) : void {
			
		}
		
		public function start(optionalParentExternalQueue : Queue = null, invokeId : String = null) : void {
			
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
	}
}