package scxml {
	import abstract.GenericState;
	
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import interfaces.IInterpreter;
	
	import r1.deval.D;
	
	import scxml.error.SCXMLValidationError;
	import scxml.invoke.Invoke;
	import scxml.invoke.InvokeASR;
	import scxml.invoke.InvokeSCXML;
	import scxml.invoke.InvokeTTS;
	import scxml.nodes.*;
	
	import util.ArrayUtils;
	
	
	public class Compiler extends EventDispatcher {
		private var doc : SCXMLDocument;
		private var counter : int = 0;
		private var interpreter : IInterpreter;
		
		public function Compiler(i : IInterpreter) {
			interpreter = i;
		}
		
		
		private function get_sid(node : XML) : String {
	        if (!node.hasOwnProperty("@id") || node.@id == "") {
	        	var id : String = "$" + ++counter;
	        	node.@id = id;
	        }
            return node.@id; 
		}
		
		private function descendantOf(node : XML, descTag : String) : Boolean {
			if(!node.parent()) return false;
			if(String(node.parent().name()) == descTag) 
				return true;
			return descendantOf(node.parent(), descTag);
		} 
		
		public function parse(xml : XML) : void {
			doc = new SCXMLDocument();
			parseRoot(xml);
			var descendants : XMLList = xml.descendants();
			for(var i : int = 0; i< descendants.length(); i++) {
				var node : XML = descendants[i];
				if(descendantOf(node, "content")) 
					continue;
				var nodeName : String = String(node.name());
				var pId : String = node.parent().@id;
				var parentState : GenericState = doc.getState(pId);
				switch(nodeName) {
					case "state":
						var newState : GenericState = doc.pushState(new SCXMLState(get_sid(node), parentState, i));
						newState.setProperties(node);
						if(isCompoundState(node))
							newState.initial = parseInitial(node);
						break;
					case "transition":	
						if(String(node.parent().name()) != "initial") {
							var transition : Transition = parseTransition(node, parentState, i);
							parentState.addTransition(transition);
						} 
						break;
					case "final":
						doc.pushState(new Final(get_sid(node), parentState, i));
						break;
					case "history":
						var history : History = doc.pushHistory(new History(get_sid(node), parentState, i));
						history.setProperties(node);
						break;
					case "parallel":
						var parallelState : GenericState = doc.pushState(new Parallel(get_sid(node), parentState, i));
//						parallelState.setProperties(node);
						break;
					case "onentry":
						var onEntry : Exec = new Exec(makeExecContent(node));
						parentState.addOnEntry(onEntry);
						break;
					case "onexit":
						var onExit : Exec = new Exec(makeExecContent(node));
						parentState.addOnExit(onExit);
						break;
					case "data":
						if(node.hasOwnProperty("@expr"))
							doc.dataModel[String(node.@id)] = evalExpr(node.@expr);
						else
							doc.dataModel[String(node.@id)] = node.toString();
							
						
						break;
					case "invoke":
						var invoke : Invoke;
						switch(String(node.@type)) {
							case "scxml":
								var inv : InvokeSCXML =  new InvokeSCXML();
								if(node.hasOwnProperty("@src"))
									inv.loadFromSource(node.@src);
								if(node.hasOwnProperty("content"))
									inv.content = XML(node.content.scxml.toString());
									
								invoke = inv;
								
								break;
							case "x-tts":
								invoke = new InvokeTTS();
								break;
							case "x-asr":
								invoke = new InvokeASR();
								break;
						}
						
						invoke.invokeid = node.@id;
						invoke.type = node.@type;
						parentState.addInvoke(invoke);
						if(node.hasOwnProperty("finalize"))
							invoke.finalizeArray = makeExecContent(XML(node.finalize));
						break;
					
				}
				
			}
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function makeExecContent(node : XML) : Array {
		    var fArray : Array = [];
	        for each(var child : XML in node.children()) {
	        	var nodeName : String = String(child.name());
//	        	peculiar scope issue hack.
	        	var getFunction : Function = function(child : XML) : Function {
	        		var f : Function;
		            switch(nodeName) {
		            	case "log":
		            		var label : String = child.hasOwnProperty("@label") ? child.@label + ": " : "Log: ";
	            			f = function() : void {
	            				trace(label + evalExpr(child.@expr));
            				};
		            		break; 
	            		case "assign":
							var expression : String = child.@expr != null ? child.@expr : child.text.toString();
	            			f = function() : void {doc.dataModel[String(child.@location)] = evalExpr(expression)};
	            			break;
	        			case "raise":
	        				f = function() : void {interpreter.raiseFunction(child.@event.split("."))};
	        				break;
	    				case "script":
							var code : String = child.toString();
	        				f = function() : void {
								evalExpr(code);
							};
	    					break;
						case "cancel":
							f = function() : void {interpreter.cancelEvent(child.@sendid)};
							break;
						case "param" :
							throw new Error("param can currently only be the child of the send tag");
						case "send":
							var type : String = child.@type != null ? child.@type : "scxml";
							var data : Object = {};
							
							if(child.hasOwnProperty("@target") && String(child.@target).slice(0,1) == "#") {
									
									switch(type) {
										case "scxml":
											break;
										case "x-asr":
											if(child.hasOwnProperty("content"))
												data["grammar"] = grammarCleanup(child.content.toString());
											break;
										case "x-tts":
											break;
									}
									
									switch(String(child.@target).slice(1)) {
										case "_parent":
											f = function() : void {
//												trace("parent send", dm["_parent"], Interpreter(interpreter).invId);
												interpreter.send(String(child.@event).split("."), child.@id, parseInt(child.@delay), appendParam(child, data), interpreter.invokeid, doc.dataModel["_parent"]); 
											};
											
											break;
										default:
											f = function() : void {
												Invoke(doc.dataModel[String(child.@target).slice(1)]).send(String(child.@event).split("."), child.@id, parseInt(child.@delay), appendParam(child, data)); 
											};
											
											break;
											
									}
									
							} else {
								// default, i.e no target specified.
								f = function() : void {
									interpreter.send(child.@event.split("."), child.@id, parseInt(child.@delay));
								};
							}
								break;
		            		default:
		            			throw new SCXMLValidationError("Parsing failed: a " + 
		            				nodeName + " node may not be the child of a " + node.name() + " node.");
								break;
							}
		        	
		        	return f;
	        	};
	        	fArray.push(getFunction(child));
			}
	        return fArray;
		}
		
		private function grammarCleanup(input : String) : String {
			return input.replace(/\n|\s\s+/g, "").replace(/;\s*/g, ";\n");
		}
		
		private function appendParam(child : XML, toObj : Object) : Object {
			if(child.hasOwnProperty("param")) {
				for each(var elem : XML in child.param) {
					if(elem.@name == "grammar")
						toObj[String(elem.@name)] = grammarCleanup(evalExpr(elem.@expr));
					else
						toObj[String(elem.@name)] = evalExpr(elem.@expr);
				}
			}
			
			if(child.hasOwnProperty("@namelist")) {
				for each(var name : String in String(child.@namelist).split(" "))
					toObj[name] = evalExpr(name);
			}
			
			return toObj;
		}
		
		private function parseRoot(node : XML) : void {
			var main : MainState = new MainState("__main__", null, 0);
			node.@id = "__main__";
			main.setProperties(node);
			main.initial = parseInitial(node);
			doc.mainState = main;
		}
		
		private function parseTransition(node : XML, source : GenericState, i : Number) : Transition {
			var t : Transition = new Transition(source);
			t.setExecFunctions(makeExecContent(node));
			if(node.hasOwnProperty("@cond"))
				t.cond = getExprFunction(node.@cond);
			if(node.hasOwnProperty("@target"))
				t.target = String(node.@target).split(" ");
			if(node.hasOwnProperty("@event"))
				t.event = ArrayUtils.map(function(x : String) : Array {return x.replace(/(.*)\.\*$/, "$1").split(".")}, node.@event.split(" ")); 
			
			return t;
		}
		
		private function isCompoundState(node : XML) : Boolean {
			return node.hasOwnProperty("state") || node.hasOwnProperty("parallel") || node.hasOwnProperty("final");
		}
		
		private function parseInitial(node : XML) : Initial {
			var initial : Initial;
			if(node.hasOwnProperty("@initial")) {
				initial = new Initial(String(node.@initial).split(" "));
			} else if(node.hasOwnProperty("initial")) {
				var transitionNode : XML = XML(node.initial).children()[0];
				initial = new Initial(String(transitionNode.@target).split(" "));
				initial.setExecFunctions(makeExecContent(transitionNode));
			} else { // has neither initial tag or attribute, so we'll make the first valid state a target instead.
				var childNodes : XMLList = node.children().(ArrayUtils.member(name(), ["state", "parallel", "final"]));
				initial = new Initial([String(childNodes[0].@id)]);
			}
			
			return initial;
		}
		
		private function getExprFunction(expr : String) : Function {
			function f() : * {
				return D.eval(expr, doc.dataModel); 
			}
			return f;
		}
		
		private function evalExpr(expr : String) : * {
			return D.eval(expr, doc.dataModel);
		}
		
		public function get document() : SCXMLDocument {
			return doc;
		}
	}
}