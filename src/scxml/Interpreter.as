package scxml {
	
	import abstract.GenericState;
	
	import datastructures.OrderedSet;
	import datastructures.Queue;
	
	import flash.events.*;
	import flash.utils.Timer;
	
	import interfaces.IExecutable;
	import interfaces.IInterpreter;
	import interfaces.IState;
	
	import mx.core.IStateClient;
	
	import scxml.events.InterpreterEvent;
	import scxml.events.InvokeEvent;
	import scxml.events.SCXMLEvent;
	import scxml.invoke.Invoke;
	import scxml.nodes.*;
	
	import util.ArrayUtils;
	
	[Event(name="finalStateReached", type="scxml.events.SCXMLEvent")]
	[Event(name="stateEntered", type="scxml.events.SCXMLEvent")]
	
	/** Given a document parsed as a <code>scmxml.SCXMLDocument</code>, 
	 * this class will interpret that document. 
	 * 
	 * @author Johan Roxendal
	 * @contact johan@roxendal.com
	 */
	public class Interpreter extends EventDispatcher implements IInterpreter {
		
		private var bContinue : Boolean = true; 

		public var configuration : OrderedSet;
		
		private var externalQueue : Queue;
		private var internalQueue : Queue;
		
		private var sendDict : Object;
		private var dm : Object;
		private var historyValue : Object;
		
		public var doc : SCXMLDocument;
		
		private var flexContainer : IStateClient;
		
		private const doLogging : Boolean = true;
		
		private var invId : String;
		
		private var statesToInvoke : OrderedSet;
		private var previousConfiguration : OrderedSet;
		
		private var macroStepEnabled : Boolean = false;
		
		
		public function Interpreter(root : IStateClient = null) {
			flexContainer = root;
			historyValue = {};
			sendDict = {};
			externalQueue = new Queue();
			externalQueue.addEventListener(Event.ADDED, onExternalEvent);
			internalQueue = new Queue();
			configuration = new OrderedSet();
			
			previousConfiguration = new OrderedSet();
			statesToInvoke = new OrderedSet();
		}
		
		public function interpret(document : SCXMLDocument, optionalParentExternalQueue : Queue = null, invokeId : String = null) : void {
			doc = document;
			dm = doc.dataModel;
			dm["_sessionid"] = "sessionid_" + (Date.parse(new Date().toString()) + new Date().milliseconds);
			
			dm["_parent"] = optionalParentExternalQueue;
			invId = invokeId;
			
			var transition : Transition = new Transition(doc.mainState);
			transition.target = doc.mainState.initial;

//			executeTransitionContent([transition]);
//			enterStates([transition]);
			microstep([transition]);
			
			startEventLoop();
		}
		
		private function startEventLoop() : void {
			
			var initialStepComplete : Boolean = false;
			while(!initialStepComplete) {
				var enabledTransitions : OrderedSet = selectEventlessTransitions();
				if(enabledTransitions.isEmpty()) {
					if(internalQueue.isEmpty()) {  
						initialStepComplete = true; 
					} else {
						var internalEvent : InterpreterEvent = internalQueue.dequeue();
						dm["_event"] = internalEvent;
						enabledTransitions = selectTransitions(internalEvent);
					}
				}
				if(!enabledTransitions.isEmpty())
					microstep(enabledTransitions);
			}
			macroStepEnabled = true;
			var timer : Timer = new Timer(0, 1);
			timer.addEventListener(TimerEvent.TIMER, function(evt : Event) : void {mainEventLoop()});
				
			if(!externalQueue.isEmpty()) 
				timer.start();
		}
		
		
		private function onExternalEvent(event : Event) : void {
//			trace("onExternalEvent", macroStepEnabled, externalQueue);
			if(!bContinue) {
				trace("The statemachine has reached it's final state(s) and is no longer accepting events.");
				return;
			}
			if(macroStepEnabled)
				mainEventLoop();
				
		}
		
		private function mainEventLoop() : void {
			
			macroStepEnabled = false;
			
            previousConfiguration = configuration;

            var externalEvent : InterpreterEvent = externalQueue.dequeue() // this call blocks until an event is available

            trace("external event found: " + externalEvent.name, "in interpreter:", invId);

            dm["_event"] = externalEvent;
            if(externalEvent.invokeid) {
				for each(var s : IState in configuration) {
					for each(var i : Invoke in s.invoke) {
                        if(i.invokeid == externalEvent.invokeid) {  // event is the result of an <invoke> in this state
                            applyFinalize(i, externalEvent);
						}
					}
				}
			}

            var enabledTransitions : OrderedSet = selectTransitions(externalEvent);
            if(!enabledTransitions.isEmpty()) {
                microstep(enabledTransitions);

                // now take any newly enabled null transitions and any transitions triggered by internal events
                var macroStepComplete : Boolean = false;
                while(!macroStepComplete) {
                    enabledTransitions = selectEventlessTransitions();
                    if(enabledTransitions.isEmpty()) {
                        if(internalQueue.isEmpty()) { 
                            macroStepComplete = true;
						} else {
                            var internalEvent : InterpreterEvent = internalQueue.dequeue() // this call returns immediately if no event is available
                            dm["event"] = internalEvent;
                            enabledTransitions = selectTransitions(internalEvent);
						}
					}

                    if(!enabledTransitions.isEmpty()) {
                         microstep(enabledTransitions);
					}
				}
			}
			
			if(!externalQueue.isEmpty())
				mainEventLoop();
			else
				macroStepEnabled = true;
		}
		
		private function exitInterpreter() : void {
	        var inFinalState : Boolean = false;
	        var statesToExit : OrderedSet = configuration.sort(exitOrder);
	        for each(var s : IState in statesToExit) {
	            for each(var content : IExecutable in s.onexit)
	                executeContent(content);
	            for each(var inv : Invoke in s.invoke)
	                cancelInvoke(inv);
	            if (isFinalState(s) && isScxmlState(s.parent))
	                inFinalState = true;
	            configuration.remove(s);
			}
	        if (inFinalState) {
	            if (invId && dm["_parent"]) 
	                dm["_parent"].enqueue(new InterpreterEvent(["done", "invoke", invId], {}))
	            trace( "Exiting interpreter", invId != null ? invId : "");
				dispatchEvent(new SCXMLEvent(SCXMLEvent.FINAL_STATE_REACHED));
			}
			
	    //        sendDoneEvent(???)
		}
		
		private function selectEventlessTransitions() : OrderedSet {
			var enabledTransitions : OrderedSet = new OrderedSet();
			var atomicStates : Array = ArrayUtils.filter(isAtomicState, configuration);
			for each(var state : IState in atomicStates) {
				if(!isPreempted(state, enabledTransitions)) {
					var done : Boolean = false;
					for each(var s : IState in [state].concat(getProperAncestors(state, null))) {
						if(done) break;
						for each(var t : Transition in s.transition) {
							if(!t.event && conditionMatch(t)) { 
								enabledTransitions.add(t)
								done = true;
								break;
							}
						}
					}
				}
			}
			return enabledTransitions;
		}
		
		private function selectTransitions(event : InterpreterEvent) : OrderedSet {
		    var enabledTransitions : OrderedSet = new OrderedSet();
		    var atomicStates : Array = ArrayUtils.filter(isAtomicState, configuration);
			
			for each(var state : IState in atomicStates) {
	            
//				if(state.invokeid && state.invokeid == event.invokeid) {  // event is the result of an <invoke> in this state
//	                applyFinalize(state, event);
//				}

	            if(!isPreempted(state, enabledTransitions)) {
	                var done : Boolean = false;
	                for each(var s : IState in [state].concat(getProperAncestors(state, null))) {
	                    if(done) break;
	                    for each(var t : Transition in s.transition) {
	                        if(t.event.length > 0 && nameMatch(t.event, event.name) && conditionMatch(t)) {
	                            enabledTransitions.add(t);
	                            done = true;
	                            break;
							}
						}
					}
				}
			}
	        return enabledTransitions;
		}
		
  		
		private function isPreempted(s : IState, transitionList : OrderedSet) : Boolean {
			var preempted : Boolean = false;
			for each(var t : Transition in transitionList) {
				if(t.target) {
					var LCA : IState = findLCA([t.source].concat(getTargetStates(t.target)));
					if (isDescendant(s, LCA)) {
						preempted = true;
						break;
					}
				}
			}
			return preempted;
		}
		
  		private function microstep(enabledTransitions : Array) : void {
		    exitStates(enabledTransitions);
		    executeTransitionContent(enabledTransitions);
		    enterStates(enabledTransitions);

			for each(var state : IState in statesToInvoke) {
				for each(var inv : Invoke in state.invoke) {
					invoke(inv, externalQueue);
				}
			}
			statesToInvoke.clear();
			
		    // Logging
	    	var config : Array = ArrayUtils.mapProperty(configuration, "id");
		    if(doLogging && config.length > 1) {
			    trace("configuration: [" + config.slice(1).join(", ") + "]");
		    }
		    // TODO: revise this
		    dispatchEvent(new SCXMLEvent(SCXMLEvent.STATE_ENTERED, config[config.length-1], enabledTransitions[0]));
		   
		}
		
		private function exitStates(enabledTransitions : Array) : void {
		    var statesToExit : OrderedSet = new OrderedSet();
	        for each(var t : Transition in enabledTransitions) {
	            if(t.target) {
	                var LCA : IState = findLCA([t.source].concat(getTargetStates(t.target)));
	                for each(var s : IState in configuration)
	                    if(isDescendant(s,LCA))
	                        statesToExit.add(s);
				}
			}

	        for each(var s1 : IState in statesToExit)
	            statesToInvoke.remove(s1);

	        statesToExit = statesToExit.sort(exitOrder);

	        for each(var s2 : IState in statesToExit) {
				var f : Function;
	            for each(var h : History in s2.history) {
	                if(h.type == History.TYPE_DEEP) {
	                    f = function(s0 : IState) : Boolean {return isAtomicState(s0) && isDescendant(s0,s2)}; 
					} else {
						f = function(s0 : IState) : Boolean {return s0.parent == s2};
					}
	                historyValue[h.id] = ArrayUtils.filter(f, configuration);
				}
			}
	        for each(var s3 : IState in statesToExit) {
	            for each(var content : IExecutable in s.onexit)
	                executeContent(content);
	            for each(var inv : Invoke in s.invoke)
	                cancelInvoke(inv);
	            configuration.remove(s3);
				
      		}
		}
		
		private function executeContent(obj : IExecutable) : void {
			if(obj.executeContent != null)
				obj.executeContent(dm)
		}
		
		private function enterStates(enabledTransitions : Array) : void {
		    var statesToEnter : OrderedSet = new OrderedSet();
		    var statesForDefaultEntry : OrderedSet = new OrderedSet();
		    for each(var t : Transition in enabledTransitions) {
		        if(t.target) {
		            var LCA : IState = findLCA([t.source].concat(getTargetStates(t.target)));
					if(isParallelState(LCA)) {
	                    for each(var child : IState in getChildStates(LCA))
	                        addStatesToEnter(child,LCA,statesToEnter,statesForDefaultEntry);
					}
	                for each(var s : IState in getTargetStates(t.target))
	                    addStatesToEnter(s,LCA,statesToEnter,statesForDefaultEntry);
					
				}
			}

	        for each(var s1 : IState in statesToEnter) {
	            statesToInvoke.add(s1);
			}

	        
	        for each(var s2 : IState in statesToEnter.sort(enterOrder)) {
	            configuration.add(s2);
	            for each(var content : IExecutable in s2.onentry)
	                executeContent(content);

	            if(statesForDefaultEntry.member(s2))
	                executeContent(s2.initial);
	            if(isFinalState(s2)) {
	                var parent : IState = s2.parent;
	                var grandparent : IState = parent.parent;
	                internalQueue.enqueue(new InterpreterEvent(["done", "state", parent.id], {}));
	                if(isParallelState(grandparent))
	                    if(ArrayUtils.all(ArrayUtils.map(isInFinalState, getChildStates(grandparent))))
	                        internalQueue.enqueue(new InterpreterEvent(["done", "state", grandparent.id], {}));
				}
			}
	        for each(var s3 : IState  in configuration)
	            if(isFinalState(s3) && isScxmlState(s3.parent)) {
	                bContinue = false;
					exitInterpreter();
				}
		}
		
		private function addStatesToEnter(s : IState, root : IState, statesToEnter : OrderedSet, statesForDefaultEntry : OrderedSet) : void {
			
			if(isHistoryState(s)) {
				if(historyValue[s.id]) { 
				    for each(var s0 : IState in historyValue[s.id]) 
				        addStatesToEnter(s0, s, statesToEnter, statesForDefaultEntry);
				} else {
				    for each(var t : Transition in s.transition) 
				        for each(var s1 : IState in getTargetStates(t.target)) 
				            addStatesToEnter(s1, s, statesToEnter, statesForDefaultEntry);
				}
			} else {
			
			    statesToEnter.add(s);
			    if(isParallelState(s)) {
			        for each(var child : IState in getChildStates(s))
			            addStatesToEnter(child,s,statesToEnter,statesForDefaultEntry);
			    } else if (isCompoundState(s)) {
					statesForDefaultEntry.add(s);
		    		for each(var targetState : IState in getTargetStates(s.initial)) {
				        addStatesToEnter(targetState,s,statesToEnter,statesForDefaultEntry);
				    }
				        
			    }
			    for each(var anc : IState in getProperAncestors(s,root)) {
			        statesToEnter.add(anc);
			        if(isParallelState(anc))
			            for each(var pChild : IState in getChildStates(anc))
			                if (!ArrayUtils.any(ArrayUtils.map(
			                	function(s : IState) : Boolean{return isDescendant(s,anc)},
			                	statesToEnter)))
			                    	addStatesToEnter(pChild,anc,statesToEnter,statesForDefaultEntry);
			    }
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
		    for each(var anc : IState in getProperAncestors(stateList[0], null)) {
		        if (ArrayUtils.all(ArrayUtils.map(
		        function(s : IState) : Boolean {return isDescendant(s,anc)}, 
		        stateList.slice(1, stateList.length))))
		            return anc;
				
			}
			return null;
	 	}
	 	
	 	private function getTargetStates(targetIDs : Array) : Array {
		    var states : Array = [];
		    for each(var id : String in targetIDs)
		        states.push(doc.getState(id));
		    return states
		}
	 	
	 	private function getProperAncestors(state : IState, root : IState) : Array {
		    var ancestors : Array = [];
		    while(state.parent && state.parent != root) {
		        state = state.parent;
		        ancestors.push(state);
		    }
		    return ancestors;
	    }
	 	
		private function executeTransitionContent(enabledTransitions : Array) : void {
			for each(var t : Transition in enabledTransitions)
				executeContent(t);
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
		
		public function nameMatch(eventList : Array, event : Array) : Boolean {
			if(ArrayUtils.member(["*"], eventList)) return true; 
		    function prefixList(l1 : Array, l2 : Array) : Boolean {
		        if(l1.length > l2.length) return false;
				
				for(var i : int = 0; i<l1.length; i++) {
					if(l1[i] != l2[i])
						return false;
				}
				return true;
			}
				
		    for each(var elem : Array in eventList) {
		        if(prefixList(elem, event))
		            return true; 
			}
		    return false;
		}
		
		private function conditionMatch(t : Transition) : Boolean {
		    if (t.cond == null)
		        return true;
		    else
		        return t.cond(dm) as Boolean;
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
		    return s.parent == null;
		}
		
		
		private function isAtomicState(s : IState) : Boolean {
			return s.state.length + s.parallel.length + s.final.length == 0;
		}
		
		
		private function isCompoundState(s : Object) : Boolean {
		    return s.state.length + s.parallel.length + s.final.length > 0;
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
		
		private function invoke(inv : Invoke, extQ : Queue) : void {
			trace("starting invoke", inv);
			dm[inv.invokeid] = inv;
			inv.addEventListener(InvokeEvent.INIT, invokeListener);
			inv.addEventListener(InvokeEvent.SEND_RESULT, invokeListener);
			inv.addEventListener(InvokeEvent.CANCEL, invokeListener);
			inv.start(extQ, inv.invokeid);
		}

		private function invokeListener(event : InvokeEvent) : void {
			var target : Invoke = Invoke(event.currentTarget);
			switch(event.type) {
				case InvokeEvent.INIT:
					send(["init", "invoke", target.invokeid], null , NaN, event.data, target.invokeid);
					break;
				case InvokeEvent.SEND_RESULT:
					var evt : Array = ["result", "invoke", target.invokeid];
					if(event.data.lastResult)
						evt.push(event.data.lastResult);
					send(evt, null , NaN, event.data, target.invokeid);
					break;
				case InvokeEvent.CANCEL:
					send(["cancel", "invoke", target.invokeid], null , NaN, {}, target.invokeid);
					break;
				
			}
		}
		
		public function applyFinalize(invoke : Invoke, event : InterpreterEvent) : void {
			invoke.finalize();
		}

		
		public function send(eventName : Object, sendId : String = null, delay : Number = 0, data : Object = null, invokeid : String = null, toQueue : Queue = null) : void {
			if(!toQueue) toQueue = externalQueue;
			if(eventName is String) eventName = eventName.split(".");
			if(!data) data = {};
			if(!delay || delay == 0) {
				toQueue.enqueue(new InterpreterEvent(eventName as Array, data, invokeid));
				return;
			}
			var timer : Timer = new Timer(delay *1000, 1);
			timer.addEventListener(TimerEvent.TIMER, function(evt : TimerEvent) : void {
				toQueue.enqueue(new InterpreterEvent(eventName as Array, data, invokeid));
	  		});
	  		if(sendId) sendDict[sendId] = timer;
	        timer.start();
		}
		
//		public function sendFunction(name : Array, data : Object, invokeid : String = null) : void {
//			externalQueue.enqueue(new InterpreterEvent(name, data, invokeid));
//		}
		
		public function raiseFunction(event : Array) : void {
			internalQueue.enqueue(new InterpreterEvent(event, {}));
		}
		
		public function cancelEvent(sendId : String) : void {
			if(sendDict[sendId])
				sendDict[sendId].stop();
			delete sendDict[sendId];
		}
		
		private function cancelInvoke(inv : Invoke) : void {
//			dm["#" + inv.invokeid] = null;
			trace("invoke cancelled", inv.invokeid);
			inv.cancel();
		}
		
		public function get invokeid() : String {
			return invId;
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
		public function isFinished() : Boolean {
			return !bContinue;
		}
	}
}