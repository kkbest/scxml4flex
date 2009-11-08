package scxml.events {
	public class InterpreterEvent {
		private var _name : String;
		public var data : Object;
		public function InterpreterEvent(name : String, data : Object = null)	{
//			TODO: needs to be expanded, see standard, 5.6.1
			if(!data) data = {};
			_name = name;
			this.data = data;
		}
		public function get name() : String {
			return _name;
		} 
		public function toString() : String {
			return "<Event name='" + name + "' />";
		}
	}
}