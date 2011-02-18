package org.apache.commons.scxml.model.nodes.actions
{
	import org.apache.commons.scxml.interfaces.IInterpreter;
	import org.apache.commons.scxml.model.SCXMLDocument;
	import org.apache.commons.scxml.model.invoke.Invoke;
	
	import r1.deval.D;
	
	/**
	 * The class in this SCXML object model that corresponds to the
	 * <send> SCXML element.
	 *
	 */
	
	public class Send implements ExecuteContent
	{
		public function Send()
		{
		}
		
		private function evalExpr(expr : String,doc:SCXMLDocument) : * {
			return D.eval(expr, doc.dataModel);
		}
		
		private function grammarCleanup(input : String) : String {
			return input.replace(/\n|\s\s+/g, "").replace(/;\s*/g, ";\n");
		}
		
		private function appendParam(child : XML, toObj : Object,doc:SCXMLDocument) : Object {
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
						toObj[String(elem.@name)] = grammarCleanup(evalExpr(expr,doc));
					else
						toObj[String(elem.@name)] = evalExpr(expr,doc);
				}
			}
			
			if(child.hasOwnProperty("@namelist")) {
				for each(var name : String in String(child.@namelist).split(" "))
				toObj[name] = evalExpr(name,doc);
			}
			
			return toObj;
		}
		
		public function execute(child : XML,doc : SCXMLDocument,interpreter : IInterpreter):Function{
				var f : Function;
				var type : String = child.hasOwnProperty("@type") ? child.@type : "scxml";
				var data : Object = {};
				function parseEvent(node : XML) : Array {
					if(node.hasOwnProperty("@event"))
						return String(node.@event).split(".");
					else if(node.hasOwnProperty("@eventexpr")) 
						return String(evalExpr(String(node.@eventexpr),doc)).split(".");
					
					return null;
				}
				
				if(!child.hasOwnProperty("@target"))
					return function() : void {
						interpreter.send(parseEvent(child), child.@id, parseInt(child.@delay));
					};
				
				if(String(child.@target).slice(0,1) == "#") {
					var target : String = String(child.@target).slice(1);
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
					
					switch(target) {
						case "_parent":
							f = function() : void {
								interpreter.send(parseEvent(child), child.@id, parseInt(child.@delay), appendParam(child, data,doc), interpreter.invokeid, doc.dataModel["_parent"]); 
							};
							
							break;
						default:
							f = function() : void {
								Invoke(doc.dataModel[target]).send(parseEvent(child), child.@id, parseInt(child.@delay), appendParam(child, data,doc)); 
							};
							
							break;
						
					}
					
				}
				
				if(f == null) throw new Error("Something went wrong in parsing of send");
				return f;
		}
	}
}