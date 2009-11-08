package scxml {
	
	import datastructures.Queue;
	import datastructures.Set;
	
	import flash.errors.IllegalOperationError;
	import flash.events.*;
	import flash.utils.Timer;
	
	import interfaces.IExecutable;
	import interfaces.IInterpreter;
	import interfaces.IState;
	
	import mx.core.IStateClient;
	
	import scxml.events.InterpreterEvent;
	import scxml.events.SCXMLEvent;
	import scxml.nodes.*;
	
	import util.ArrayUtils;  
	
	/** Given a document parsed as a <code>scmxml.SCXMLDocument</code>, 
	 * this class will interpret that document. 
	 * 
	 * TODO: test cond. 
	 * 
	 * @author Johan Roxendal
	 */
	public class Interpreter extends EventDispatcher implements IInterpreter {
		
		private var bContinue : Boolean = true; 

		protected var configuration : Set;
		
		private var externalQueue : Queue;
		private var internalQueue : Queue;
		
		private var sendDict : Object;
		private var dm : Object;
		private var historyValue : Object;
		
		protected var doc : SCXMLDocument;
		
		private var flexContainer : IStateClient;
		
		private const doLogging : Boolean = true;
		
		public function Interpreter(root : IStateClient = null) {
			flexContainer = root;
			historyValue = {};
			sendDict = {};
			externalQueue = new Queue();
			internalQueue = new Queue();
			configuration = new Set();
		}
		
		public function interpret(input : SCXMLDocument) : void {
			doc = input;
			dm = doc.dataModel;

			var transition : Transition = new Transition(doc.mainState);
			transition.target = doc.mainState.initial;

		   	macrostep(new Set([transition]));
			
			var timer : Timer = new Timer(100);
			timer.addEventListener(TimerEvent.TIMER, function(evt : Event) : void {startEventLoop()});
			timer.start();
			
		}
		
		protected function onAppFinalState() : void {
			bContinue = false;
		}
		
		private function startEventLoop() : void {
		    if(bContinue) {
		        var ee : InterpreterEvent = externalQueue.dequeue();
		        dm["_event"] = ee;
		        if(ee && doLogging)
			        trace("Ext. event: " + ee.name);
		        var enabledTransitions : Set = selectTransitions(ee);
		        if(!enabledTransitions.isEmpty())
		            macrostep(enabledTransitions)
		    }
		}
		private function macrostep(enabledTransitions : Set) : void {
		    microstep(enabledTransitions);
		    while(bContinue) {
		        enabledTransitions = selectTransitions(null);
		        if(enabledTransitions.isEmpty() && !internalQueue.isEmpty()) {
		            var ie : InterpreterEvent = internalQueue.dequeue();
		            dm["_event"] = ie;
		            trace( "Int. event: " + ie.name);
		            enabledTransitions = selectTransitions(ie);
		        }
		        if(!enabledTransitions.isEmpty()) 
		            microstep(enabledTransitions)
		        else 
		            if(internalQueue.isEmpty())
		                break;
		    }
		}
		private function selectTransitions(event : InterpreterEvent) : Set {
		    var enabledTransitions : Set = new Set();
		    var atomicStates : Set = configuration.filter(isAtomicState);
			
			var done : Boolean = false;;
		    for each(var state : IState in atomicStates.toList()) {
		        for each(var s : IState in [state].concat(getProperAncestors(state,null))) { 
		        	if(done) break;
		            for each(var t : Transition in s.transition) {
		                if((!event && !t.event && conditionMatch(t)) || 
		                    (event && nameMatch(event,t) && conditionMatch(t))) {
		                   enabledTransitions.add(t);
		                   break;
	                    }
		            }
		        }
		    }
		    return enabledTransitions;
		}
  		
  		private function microstep(enabledTransitions : Set) : void {
		    exitStates(enabledTransitions);
		    executeContent(enabledTransitions.toList());
		    enterStates(enabledTransitions);
		    // Logging

	    	var config : Array = ArrayUtils.mapProperty(configuration.toList(), "id");
		    if(doLogging) {
			    trace("configuration: [" + config.slice(1).join(", ") + "]");
		    }
		    // TODO: revise this
		    dispatchEvent(new SCXMLEvent(SCXMLEvent.STATE_ENTERED, config[config.length-1], enabledTransitions.toList()[0]));
		   
		}
		
		private function exitStates(enabledTransitions : Set) : void {
		    var statesToExit : Set = new Set();
		    for each(var t : Transition in enabledTransitions.toList()) {
		        if (t.target) {
		            var LCA : IState = findLCA([t.source].concat(getTargetStates(t.target)));
		            for each(var s : IState in configuration.toList()) {
		                if (isDescendant(s,LCA))
		                    statesToExit.add(s)
		            }
          		}
      		}
		    var stateList : Array = statesToExit.toList();
		    stateList.sort(exitOrder);
		    for each(var s1 : IState in stateList) {
		        for each(var h : History in s1.history) {
		        	var f : Function;
		        	if (h.type == History.TYPE_DEEP) 
			            f = function(s0:IState) : Boolean {
			            	return isAtomicState(s0) || isDescendant(s0,s1);
			            }  
		            else 
			            f = function(s0:IState) : Boolean {
			            	return s0.parent == s1;
			            } 
		            historyValue[h.id] = ArrayUtils.filter(f, configuration.toList());
	            }
		    }
		    for each(var s2 : IState in stateList) {
		        executeContent(s2.onexit);
		        for each(var inv : Invoke in s2.invoke) 
		            cancelInvoke(inv) //missing?
		        configuration.remove(s2)
		    }
		}
		private function executeContent(elements : Array) : void {
		    for each(var e : IExecutable in elements)
		    	e.executeContent(flexContainer, dm);
//	    	    if(e.exe != null) {
//	    	    	e.exe["In"] = function(id : String) : Boolean {return configuration.member(doc.getState(id))};
//		    	    e.exe(flexContainer, dm);
		    	    
//		    	   }
		}
		
		
		private function enterStates(enabledTransitions : Set) : void {
		    var statesToEnter : Set = new Set();
		    var statesForDefaultEntry : Set = new Set();
		    for each(var t : Transition in enabledTransitions.toList()) {
		        if (t.target) {
		            var LCA : IState = findLCA([t.source].concat(getTargetStates(t.target)));
		            for each (var s : IState in getTargetStates(t.target)) {
		                if (isHistoryState(s)) {
		                    if (historyValue[s.id])
		                        for each(var s0 : IState in historyValue[s.id])
		                            addStatesToEnter(s0,LCA,statesToEnter,statesForDefaultEntry);
		                    else
		                        for each(var s1 : IState in getTargetStates(s.transition[0].target))
		                            addStatesToEnter(s1,LCA,statesToEnter,statesForDefaultEntry); 
		                } else
		                    addStatesToEnter(s,LCA,statesToEnter,statesForDefaultEntry);
		            }
		            if (isParallelState(LCA))
		                for each(var child : IState in getChildStates(LCA))
		                    addStatesToEnter(child,LCA,statesToEnter,statesForDefaultEntry);
	            }
      		}
      		var stateList : Array = statesToEnter.toList();
		    stateList.sort(enterOrder);
		    for each(var s3 : IState in stateList) {
		        configuration.add(s3);
		        switchFlexState(s3);
		        
		//      for inv in s.invoke:
		//         sessionid = executeInvoke(inv)
		//         datamodel.assignValue(inv.attribute('id'),sessionid)
		        executeContent(s3.onentry);
		        
		        // transition exec content for initial tags not implemented
//		        if(statesForDefaultEntry.member(s3))
//		        	if(s3.initExec)
//			            executeContent([s3.initExec]);
		        
		        if(isFinalState(s3)) {
		            var parent : IState = s3.parent;
		            var grandparent : IState = parent.parent;
		            internalQueue.enqueue(parent.id + ".Done");
		            if (isParallelState(grandparent))
		                if(ArrayUtils.all(ArrayUtils.map(isInFinalState, getChildStates(grandparent))))
	                    	internalQueue.enqueue(grandparent.id + ".Done");
          		}
      		}
		    for each(var s4 : IState in configuration.toList())
		        if (isFinalState(s4) && isScxmlState(s4.parent))
		            onAppFinalState();
		}
		
		private function addStatesToEnter(s : IState, root : IState, statesToEnter : Set, statesForDefaultEntry : Set) : void {
		    statesToEnter.add(s);
		    if(isParallelState(s)) {
		        for each(var child : IState in getChildStates(s))
		            addStatesToEnter(child,s,statesToEnter,statesForDefaultEntry);
		    } else if (isCompoundState(s)) {
	    		for each(var targetState : IState in getTargetStates(s.initial)) {
			        statesForDefaultEntry.add(targetState);
			        addStatesToEnter(targetState,s,statesToEnter,statesForDefaultEntry);
			    }
			        
		    }
		    for each(var anc : IState in getProperAncestors(s,root)) {
		        statesToEnter.add(anc)
		        if (isParallelState(anc))
		            for each(var pChild : IState in getChildStates(anc))
		                if (!ArrayUtils.any(ArrayUtils.map(
		                	function(s : IState) : Boolean{return isDescendant(s,anc)},
		                	statesToEnter.toList())))
		                    	addStatesToEnter(pChild,anc,statesToEnter,statesForDefaultEntry)
		    }
		}
	
		private function isInFinalState(state : IState) : Boolean {
		    if (isCompoundState(state))
		        return ArrayUtils.any(ArrayUtils.map(
		        	function(s : IState) : Boolean {return isFinalState(s) && configuration.member(s)}, 
		        	getChildStates(state)));
		    else if( isParallelState(state))
		        return ArrayUtils.all(ArrayUtils.map(isInFinalState, getChildStates(state)));
		    else
		        return false;
	 	}
	 	
	 	private function findLCA(stateList : Array) : IState {
		    for each(var anc : IState in getProperAncestors(stateList[0], null))
		        if (ArrayUtils.all(ArrayUtils.map(
		        function(s : *) : Boolean {return isDescendant(s,anc)}, 
		        stateList.slice(1, stateList.length))))
		            return anc;
            trace("findLCA, fail");
            return null;
	 	}
	 	
	 	private function getTargetStates(targetIDs : Array) : Array {
		    var states : Array = [];
		    for(var i : int = 0; i< targetIDs.length; i++)
		        states.push(doc.getState(targetIDs[i]));
		    return states
		}
	 	
	 	private function getProperAncestors(state : IState, root : IState) : Array {
		    var ancestors : Array = [];
		    while(state && state.parent != root) {
		        state = state.parent;
		        ancestors.push(state);
		    }
		    return ancestors;
	    }
	 	
	 	private function isDescendant(state1 : IState, state2 : IState) : Boolean {
		    while (state1) {
		        state1 = state1.parent
		        if (state1 == state2)
		            return true;
		    }
		    return false;
		}
		
		public function getChildStates(state : IState) : Array {
		    return state.getChildStates();
		}
		
		public function nameMatch(event : InterpreterEvent, t : Transition) : Boolean {
		    if (!t.event || !event)
		        return false;
		    else
		        return t.event == event.name;
		}
		
		private function conditionMatch(t : Transition) : Boolean {
		    if (t.cond == null)
		        return true;
		    else
		        return t.cond(dm)
		}
		
		private function isParallelState(s : IState) : Boolean {
    		return s is Parallel;
  		}


		private function isFinalState(s : IState) : Boolean {
		    return s is Final;
		}
		
		private function isHistoryState(s : IState) : Boolean {
		    return s is History;
		}
		
		
		private function isScxmlState(s : IState) : Boolean {
		    return Boolean(s.parent);
		}
		
		
		private function isAtomicState(s : IState) : Boolean {
		    return s.isAtomicState;
		}
		
		
		private function isCompoundState(s : IState) : Boolean {
		    return s.isCompoundState;
		}
		
		private function documentOrder(s1 : IState, s2 : IState) : Number {
		    if (s1.n < s2.n)
		        return 1;
		    else
		        return -1;
		}

		private function enterOrder(s1  : IState, s2 : IState) : Number {
		    if (isDescendant(s1,s2))
		        return 1;
		    else if(isDescendant(s2,s1))
		        return -1;
		    else 
		        return documentOrder(s1,s2);
		}

		private function exitOrder(s1 : IState, s2 : IState) : Number {
		    if(isDescendant(s1,s2))
		        return -1;
		    else if(isDescendant(s2,s1))
		        return 1;
		    else
		        return documentOrder(s2,s1);
		}


		public function send(eventName : String, sendId : String = null, data : Object = null, delay : Number = 0) : void {
//			TODO: need to be expanded by quite a bit. 
			if(!data) data = {};
			var timer : Timer = new Timer(delay *1000, 1);
			timer.addEventListener(TimerEvent.TIMER, function(evt : TimerEvent) : void {
	        	externalQueue.enqueue(new InterpreterEvent(eventName, data));
	  		});
	  		if(sendId) sendDict[sendId] = timer;
	        timer.start();
		}
		
		public function cancelEvent(sendId : String) : void {
			if(sendDict[sendId])
				sendDict[sendId].stop();
			delete sendDict[sendId];
		}
		
		private function cancelInvoke(inv : Invoke) : void {
			throw new IllegalOperationError("cancelInvoke not yet implemented");
		}
		
		public function set root(container : IStateClient) : void {
			flexContainer = container;
		} 
		
		private function switchFlexState(s : IState) : void {
			var viewState : String = s.viewstate;
			if(viewState != null && flexContainer) {
				flexContainer.currentState = viewState;
				if(doLogging)
					trace("current viewstate: " + viewState);
			}
		}
	}
}