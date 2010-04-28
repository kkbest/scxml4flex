package scxml.nodes {
	import abstract.GenericState;
	
	import interfaces.IState;
	public class History extends GenericState {
		public static var TYPE_DEEP : String = "deep";
		public static var TYPE_SHALLOW : String = "shallow";
		
		private var _type : String = "shallow";
		
		public function History(sId : String, pState : IState, num : Number = NaN) { 
			super(sId, pState, num);
			 
			optionalProperties = ["type"];
		}
		public function get type() : String {
			return _type;
		}
		public function set type(s : String) : void {
			trace("type", s);
			_type = s;
			if(_type != TYPE_SHALLOW || _type != TYPE_DEEP) 
				throw new Error("History type must equal 'deep' or 'shallow'");
		}
	}
}