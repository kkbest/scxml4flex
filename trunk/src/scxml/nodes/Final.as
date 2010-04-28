package scxml.nodes {
	import abstract.GenericState;
	
	import interfaces.IState;
	
	import scxml.error.SCXMLValidationError;
	
	public class Final extends GenericState {
		
		public function Final(sId : String, pState : IState, num : Number = NaN) {
			super(sId, pState, num);
		}
		
		override public function set initial(s : Initial) : void {
			throw new SCXMLValidationError("Inital tag not allowed as child of Final");
		} 
		override public function get initial() : Initial {
			return new Initial([]);
		}
		
		override public function get transition() : Array {
			return [];
		}
		override public function get history() : Array {
			return [];
		}
	}
}