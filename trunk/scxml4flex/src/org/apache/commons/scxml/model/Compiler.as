package org.apache.commons.scxml.model {
	import flash.errors.IllegalOperationError;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getDefinitionByName;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.apache.commons.scxml.abstract.GenericState;
	import org.apache.commons.scxml.datastructures.CustomActionClassMap;
	import org.apache.commons.scxml.interfaces.IInterpreter;
	import org.apache.commons.scxml.model.error.SCXMLValidationError;
	import org.apache.commons.scxml.model.invoke.Invoke;
	import org.apache.commons.scxml.model.invoke.InvokeSCXML;
	import org.apache.commons.scxml.model.nodes.*;
	import org.apache.commons.scxml.model.nodes.actions.*;
	import org.apache.commons.scxml.model.nodes.actions.ExecuteContentRegister;
	import org.apache.commons.scxml.util.ArrayUtils;
	
	import r1.deval.D;
	
	
	public class Compiler extends EventDispatcher {
		private var doc : SCXMLDocument;
		private var counter : int = 0;
		private var interpreter : IInterpreter;
		private var customActionList:Array;
		
		private static const logger:ILogger = Log.getLogger("Compiler");
		
		default xml namespace = new Namespace("http://www.w3.org/2005/07/scxml");
		namespace scxml4flex = "http://code.google.com/p/scxml4flex";
		
		public function Compiler(i : IInterpreter) {
			interpreter = i;
		}
		
		public function setCustomAction(caList:Array):void{
			customActionList=caList;
		}
		
		public function get_sid(node : XML) : String {
	        if (!node.hasOwnProperty("@id") || node.@id == "") {
	        	var id : String = "_" + node.localName() + "_" + ++counter;
	        	node.@id = id;
	        }
            return node.@id; 
		}
		
		private function descendantOf(node : XML, descTag : String) : Boolean {
			if(!node.parent()) return false;
			if(String(node.parent().localName()) == descTag) 
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
				var nodeName : String = String(node.localName());
				var pId : String = node.parent().@id;
				var parentState : GenericState = doc.getState(pId);
				
				//state SCXML element parse job
				var register:ElementRegister=new ElementRegister();
				for(var m:int=0;m<register.elementsList.length;m++){
					var eachEle:CustomActionClassMap=register.elementsList[m];
					if(eachEle.getElementName()==nodeName){
						var ClassReference:Class = getDefinitionByName(eachEle.getClassPath()) as Class;
						var action:ElementContent = new ClassReference() as ElementContent;
						action.compile(node,parentState,doc,this,i);
						break;
					}
				}	
			}
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function makeExecContent(node : XML) : Array {
		    var fArray : Array = [];
	        for each(var child : XML in node.children()) {
	        	var nodeName : String = String(child.localName());
				/*
				If we want to use ActionScript reflection mechanism, we must make sure the imported class includes in comiled SWF file
				Or we can get #1065 error, so, if we catch any error, we use var aic:ActionImportClass = null to package the aim classes
				in to compiled SWF file
				*/
	        	var getFunction : Function = function(child : XML) : Function {
	        		var f : Function = null;
					var match:Boolean = false;
					for(var i:int=0;i<ExecuteContentRegister.executeContentList.length;i++){
						var eachExec:CustomActionClassMap=ExecuteContentRegister.executeContentList[i];
						if(eachExec.getElementName()==nodeName){
							var ClassReference:Class = getDefinitionByName(eachExec.getClassPath()) as Class;
							var action:ExecuteContent = new ClassReference() as ExecuteContent;
							f=action.execute(child,doc,interpreter);
							match = true;
							break;
						}
					}
					//Parse CustomAction elements
					if(!match){
						var namespace:String=String(child.namespace());
						for(var k:int=0;k<customActionList.length;k++){
							var ca:CustomAction=customActionList[k];
							if(namespace==ca.getNamespaceURI()&&nodeName==ca.getLocalName()){
								try{
									var CustomClassReference:Class = ca.getActionClass();
									var customAction:ExecuteContent = new CustomClassReference() as ExecuteContent;
									f=customAction.execute(child,doc,interpreter);
									match = true;
									break;
								}catch(e:Error){
									trace("Bad CustomAction Element, it must implements interface ExecuteContent");
									throw new ErrorEvent("Bad CustomAction Element, it must implements interface ExecuteContent");
								}
							}
						}
					}
						
					//Bad element, return empty function
					if(!match){
						//throw new SCXMLValidationError("Parsing failed: a " +nodeName + " node may not be the child of a " + node.localName() + " node.");
						trace("Parsing failed: a " +child.namespace()+ 
							nodeName + " node may not be the child of a " + node.localName() + " node.");
						f=function():void{}; 
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
					var expr : String = elem.hasOwnProperty("@expr") ? elem.@expr : elem.@name;
					if(elem.hasOwnProperty("@expr"))
						expr = elem.@expr;
					// not necesarily standars compliant (hard to tell):
					else if(doc.dataModel.hasOwnProperty(String(elem.@name)))
						expr = elem.@name;
					else
						expr = "";
					if(elem.@name == "grammar")
						toObj[String(elem.@name)] = grammarCleanup(evalExpr(expr));
					else
						toObj[String(elem.@name)] = evalExpr(expr);
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
			main.initial = parseInitial(node);
			doc.mainState = main;
			if(node.hasOwnProperty("script"))
				evalExpr(XML(node.script).toString());
		}
		
		public function parseInitial(node : XML) : Initial {
			var initial : Initial;
			if(node.hasOwnProperty("@initial")) {
				initial = new Initial(String(node.@initial).split(" "));
			} else if(node.hasOwnProperty("initial")) {
				var transitionNode : XML = XML(node.initial).children()[0];
				initial = new Initial(String(transitionNode.@target).split(" "));
				initial.setExecFunctions(makeExecContent(transitionNode));
			} else { // has neither initial tag or attribute, so we'll make the first valid state a target instead.
				var childNodes : XMLList = node.children().(ArrayUtils.member(localName(), ["state", "parallel", "final"]));
				initial = new Initial([String(get_sid(childNodes[0]))]);
			}
			return initial;
		}
		
		public function getExprFunction(expr : String) : Function {
			function f() : * {
				return D.eval(expr, doc.dataModel); 
			}
			return f;
		}
		
		public function evalExpr(expr : String) : * {
			return D.eval(expr, doc.dataModel);
		}
		
		public function get document() : SCXMLDocument {
			return doc;
		}
		
		private function debug(msg : String, ...args : Array) : void {
			var argArray : Array = ArrayUtils.map(function(n : Number) : String {return "{" + n + "}"}, ArrayUtils.range(0, args.length));
			logger.debug.apply(null, [msg + " " + argArray.join(" ")].concat(args));
		}
	}
}