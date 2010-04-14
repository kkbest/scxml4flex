package abstract {
	import flash.errors.IllegalOperationError;
	
	import interfaces.IExecutable;
	import interfaces.IState;
	
	import scxml.nodes.History;
	import scxml.nodes.Initial;
	import scxml.nodes.Transition;
	
	
	public class GenericState extends SCXMLNode implements IState {
        
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
        protected var state : Array;
        protected var parallel : Array;
        protected var invokeArray : Array;
        
//        protected var initTransitionFunction : IExecutable;
        
		public function GenericState(sId : String, pState : IState, num : Number = NaN) {
			onEntryArray = [];
			onExitArray = [];
			transitionArray = [];
			state = [];
			parallel = [];
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
			return [].concat(state, parallel, finalStates, historyArray);
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
		
		public function get isAtomicState() : Boolean {
			return state.length == 0 && parallel.length == 0 && finalStates.length == 0;
		}
		public function get isCompoundState() : Boolean {
			return (state.length > 0 || parallel.length > 0 || finalStates.length > 0);
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
		
//		public function set initExec(f : IExecutable) : void {
//			initTransitionFunction = f;
//		}
//		public function get initExec() : IExecutable {
//			return initTransitionFunction;
//		}
		
		override public function setProperties(node : XML) : void {
			if(!optionalProperties) throw new IllegalOperationError("optionalProperties is empty, this property must be overwritten.");
			for each(var p : String in optionalProperties)
				if(node.hasOwnProperty("@" + p))
					if(p == "initial")
						this[p] = new Initial(String(node.@[p]).split(" "));
					else
						this[p] = String(node.@[p]);
		}
	}
}