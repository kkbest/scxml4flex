package abstract {
	import flash.errors.IllegalOperationError;
	
	import interfaces.IExecutable;
	import interfaces.IState;
	
	import scxml.invoke.Invoke;
	import scxml.nodes.*;
	
	
	public class GenericState implements IState {
        
        protected var onExitArray : Array;
        protected var onEntryArray : Array;
        
        protected var parentState : IState;
        
        protected var sId : String;
        protected var nNum : Number;
        protected var invId : String;
		
        
        protected var initialStates : Initial; 
        protected var finalStates : Array;
        protected var historyArray : Array;
		protected var transitionArray : Array;
        protected var stateArray : Array;
        protected var parallelArray : Array;
        protected var invokeArray : Array;
        
//        protected var initTransitionFunction : IExecutable;
        
		public function GenericState(sId : String, pState : IState, num : Number = NaN) {
			onEntryArray = [];
			onExitArray = [];
			transitionArray = [];
			stateArray = [];
			parallelArray = [];
			finalStates = [];
			invokeArray = [];
			historyArray = [];
			
			parentState = pState;
			this.sId = sId;
			nNum = num;
		}
		
		public function get n() : Number {
			return nNum;
		}
		public function get parent() : IState {
		 	return parentState;
		}
		public function get id() : String {
			return sId;
		}
		
		public function get transition() : Array {
			return transitionArray;
		}
		public function get history() : Array {
			return historyArray;
		}
		
		public function get invoke() : Array {
			return invokeArray;
		}
		
		public function set initial(s : Initial) : void {
			initialStates = s;
		} 
		public function get initial() : Initial {
			return initialStates;
		}
		public function get state() : Array {
			return stateArray;
		}
		public function get finalArray() : Array {
			return finalStates;
		}
		public function get parallel() : Array {
			return parallelArray;
		}
		
		public function get onexit() : Array {
			return onExitArray;
		}
		public function get onentry() : Array {
			return onEntryArray;
		}
		public function addOnEntry(e : IExecutable) : void {
			onEntryArray.push(e);
		}
		public function addOnExit(e : IExecutable) : void {
			onExitArray.push(e);
		}
		
		public function getChildStates() : Array {
			return [].concat(stateArray, parallelArray, finalStates, historyArray);
		}
		public function addState(s : GenericState) : void {
			//TODO: but what if the GenericState is a Parallel?
			state.push(s);
		}
		public function addTransition(t : Transition) : void {
			transitionArray.push(t);
		}
		public function addHistory(s : History) : void {
			historyArray.push(s);
		}
		public function addInvoke(inv : Invoke) : void {
			invokeArray.push(inv);
		}
		
		public function get viewstate() : String {
			return null;
		}
		
		public function set invokeid(id : String) : void {
			invId = id;
		}
		public function get invokeid() : String {
			return invId;
		}
	}
}