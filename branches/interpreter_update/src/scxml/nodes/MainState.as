package scxml.nodes
{
	import abstract.GenericState;
	
	import interfaces.IState;
	
	public class MainState extends GenericState {
		public function MainState(sId : String, pState : IState, num : Number = NaN) {
			super(sId, pState, num);
			optionalProperties = ["initial", "name", "xmlns", "version", "profile", "exmode"];
		}
		
		

	}
}