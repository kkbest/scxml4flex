package org.apache.commons.scxml.model.nodes
{
	import org.apache.commons.scxml.abstract.GenericState;
	
	import org.apache.commons.scxml.interfaces.IState;
	
	public class MainState extends GenericState {
		public function MainState(sId : String, pState : IState, num : Number = NaN) {
			super(sId, pState, num);
		}
		
		

	}
}