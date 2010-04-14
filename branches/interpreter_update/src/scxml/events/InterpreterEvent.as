package scxml.events {
	public class InterpreterEvent {
		private var _name : Array;
		public var data : Object;
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
			throw new Error("InterpreterEvent.invokeid not implemented");
		}
		public function toString() : String {
			return "<Event name='" + name + "' />";
		}
	}
}