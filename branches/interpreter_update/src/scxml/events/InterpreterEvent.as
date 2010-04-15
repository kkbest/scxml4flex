package scxml.events {
	public class InterpreterEvent {
		private var _name : Array;
		public var data : Object;
		private var invId : String = "";
		public function InterpreterEvent(name : Array, data : Object = null)	{
//			TODO: needs to be expanded, see standard, 5.6.1
			if(!data) data = {};
			_name = name;
			this.data = data;
		}
		public function get name() : Array {
			return _name;
		} 
		public function get invokeid() : String {
			return invId;
		}
		public function toString() : String {
			return "<Event name='" + name + "' />";
		}
	}
}