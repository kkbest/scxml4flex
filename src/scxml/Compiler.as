package scxml {
	import abstract.GenericState;
	
	import flash.display.Loader;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	
	import interfaces.IInterpreter;
	
	import r1.deval.D;
	
	import scxml.error.SCXMLValidationError;
	import scxml.nodes.*;
	
	import util.UrlTools;
	
	
	public class Compiler extends EventDispatcher {
		private var doc : SCXMLDocument;
		private var counter : int = 0;
		private var interpreter : IInterpreter;
//		private var fMap : Object;
//		private var condMap : Object;
		
		public function Compiler(i : IInterpreter) {
			interpreter = i;
		}
		
		/*
		private function loadFunctions(xmlData : XML) : void {
			var descendants : XMLList = xmlData.descendants();
			if(descendants.(hasOwnProperty("script") || hasOwnProperty("@cond")).length() == 0) { 
				main(xmlData);
				return;
			}
			
			var loader : Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event : Event) : void {
				fMap = Object(loader.content).fMap;
				condMap = Object(loader.content).condMap;
				main(xmlData);
			});
			// look into if normal escape() builtin works.
			loader.load(new URLRequest('/cgi-bin/scxml/ascompiler.py?xmldata=' + UrlTools.escape(xmlData.toXMLString())));
		}
		*/
		
		public function parse(xml : XML) : void {
//			loadFunctions(xml);
			main(xml);
		}
		
		private function get_sid(node : XML) : String {
	        if (!node.hasOwnProperty("@id") || node.@id == "") {
	        	var id : String = "$" + ++counter;
	        	node.@id = id;
	        }
            return node.@id; 
		}
		
		private function main(xml : XML) : void {
			doc = new SCXMLDocument();
			parseRoot(xml);
			var descendants : XMLList = xml.descendants();
			for(var i : int = 0; i< descendants.length(); i++) {
				var node : XML = descendants[i];
				var nodeName : String = String(node.name());
				var pId : String = node.parent().@id;
				var parentState : GenericState = doc.getState(pId);
				switch(nodeName) {
					case "state":
						var newState : GenericState = doc.pushState(new SCXMLState(get_sid(node), parentState, i));
						newState.setProperties(node);
						break;
					case "transition":	// kolla ifall 'in'-predikatet funkar.
						if(String(node.parent().name()) != "initial") {
							var transition : Transition = parseTransition(node, parentState, i);
							parentState.addTransition(transition);
						} else 
							doc.getState(node.parent().parent().@id).initial = node.@target.split(" ");
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
						parallelState.setProperties(node);
						break;
					case "onentry":
						var onEntry : Exec = new Exec(makeExecContent(node, i));
						parentState.addOnEntry(onEntry);
						break;
					case "onexit":
						var onExit : Exec = new Exec(makeExecContent(node, i));
						parentState.addOnExit(onExit);
						break;
					case "data":
						doc.dataModel[String(node.@id)] = evalExpr(node.@expr);
						break;
					case "initial":
						var transitionNode : XML = node.children()[0];
						parentState.initial = new Initial(transitionNode.@target.split(" "));
						
						parentState.initial.setExecFunctions(makeExecContent(transitionNode, i));
						break;
					
				}
				
			}
			// initial transition exec currently not supported.
//			var list : XMLListCollection = new XMLListCollection(descendants);
//			var a : Array = ArrayUtils.filter(
//				function(item:XML) : Boolean {return item.hasOwnProperty("initial")}, 
//				[xml].concat(list.toArray())
//				);
//			for each(var pInitial : XML in a) {
//				var targetParent : GenericState = doc.getState(pInitial.@id);
//				var val : Array = String(pInitial.initial.transition.@target).split(" ");
//				targetParent.initial = val;
//				for each(var sId : String in val)
//					doc.getState(sId).initExec = new GenericExec(makeExecContent(pInitial.initial.transition[0]));
//
//			}
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function makeExecContent(node : XML, i : Number) : Array {
		    var fArray : Array = [];
	        for each(var child : XML in node.children()) {
	        	var nodeName : String = String(child.name());
//	        	peculiar scope issue hack.
	        	var getFunction : Function = function(child : XML) : Function {
	        		var f : Function;
		            switch(nodeName) {
		            	case "log":
		            		var label : String = child.hasOwnProperty("@label") ? child.@label + ": " : "Log: ";
	            			f = function(dm : Object) : void {
	            				trace(label + evalExpr(child.@expr));
            				};
		            		break; 
	            		case "assign":
							var expression : String = child.@expr != null ? child.@expr : child.text;
	            			f = function(dm : Object) : void {dm[String(child.@location)] = evalExpr(expression)};
	            			break;
	        			case "raise":
	        				f = function(dm : Object) : void {interpreter.raiseFunction(child.@event.split("."))};
	        				f["data"] = child.@id;
	        				break;
//	        			case "flexfunction":
//	        				f = function(dm : Object) : void {
//	        					ExternalInterface.call("callApp", String(child.@name), String(child.@params))
//        					};
//	        				break;
	    				case "script":
							throw new Error("Script not implemented");
//							f = fMap[i];
	    					break;
						case "cancel":
							f = function(dm : Object) : void {interpreter.cancelEvent(child.@sendid)};
							break;
						case "param" :
							if(!child.hasOwnProperty("@expr") || child.parent.name() != "transition") 
								throw new IllegalOperationError("only event params implemented, param must be the child of a transition node");
							f = function(dm : Object) : void {
//								TODO: this is a simplification, read the standard.
								var n : String = child.@name;
								var e : String = child.@expr;
								dm._event.data[n] =  e;
							};
							break;
						case "send":
							f = function(dm : Object) : void {interpreter.send(child.@event.split("."), child.@id, parseInt(child.@delay))};
							break;
	            		default:
	            			throw new SCXMLValidationError("Parsing failed: a " + 
	            				nodeName + " node may not be the child of a " + node.name() + " node.");
		        	}
		        	return f;
	        	};
	        	fArray.push(getFunction(child));
			}
	        return fArray;
		}
/*		
		private function parseExpr(target : Object, expr : String) : String {
			var hasDm : RegExp = new RegExp("^dm\\.", "");
			return hasDm.test(expr) ? String(ExpressionParser.access(target, expr.slice(3))) : expr;
		}
		*/
		
		private function parseRoot(node : XML) : void {
			var main : MainState = new MainState("__main__", null, 0);
			node.@id = "__main__";
			main.setProperties(node);
			
//			doc.pushState(main);
			doc.mainState = main;
		}
		
		private function parseTransition(node : XML, source : GenericState, i : Number) : Transition {
			var t : Transition = new Transition(source);
			t.setProperties(node);
			t.setExecFunctions(makeExecContent(node, i));
			if(node.hasOwnProperty("@cond"))
				t.cond = getExprFunction(node.@cond);
			return t;
		}
		
		private function getExprFunction(expr : String) : Function {
			function f(dm : Object) : * {
				return D.eval(expr, {"dm" : dm}); 
			}
			return f;
		}
		
		private function evalExpr(expr : String) : * {
			return D.eval(expr, {"dm" : doc.dataModel});
		}
		
		public function get document() : SCXMLDocument {
			return doc;
		}
	}
}