package org.apache.commons.scxml.model.nodes.actions
{
	import flash.events.ErrorEvent;
	import flash.utils.getDefinitionByName;
	
	import org.apache.commons.scxml.datastructures.CustomActionClassMap;
	import org.apache.commons.scxml.interfaces.IInterpreter;
	import org.apache.commons.scxml.model.Compiler;
	import org.apache.commons.scxml.model.SCXMLDocument;
	
	import r1.deval.D;
	
	/**
	 * The class in this SCXML object model that corresponds to the
	 * <if> SCXML element.
	 *
	 */
	
	public class If implements ExecuteContent
	{
		private var funList: Array = new Array();
		private var current:Boolean = true;
		private var elseIfList : Array = new Array();
		private var cElseIf:ElseIf = null;
		private var cElse:Else = null;
		
		public function getExprFunction(expr : String,doc : SCXMLDocument) : Function {
			function f() : * {
				return D.eval(expr, doc.dataModel); 
			}
			return f;
		}
		
		private function conditionMatch(cond : Function) : Boolean {
			if (cond == null)
				return true;
			else
				return cond.call() as Boolean;
		}
		
		
		public function parseIf(node : XML,doc : SCXMLDocument,interpreter : IInterpreter) : void {
			var fArray : Array = [];
			for each(var child : XML in node.children()) {
				var nodeName : String = String(child.localName());
				if(nodeName=="elseif"){
					current=false;
					var cond : Function = null;
					if(child.hasOwnProperty("@cond")) cond = getExprFunction(child.@cond,doc);
					if(cElseIf!=null){
						elseIfList.push(cElseIf);
					}
					cElseIf=new ElseIf();
					cElseIf.cond=cond;
				}else if(nodeName=="else"){
					current=false;
					cElseIf=null;
					cElse=new Else();
				}else{
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
							for(var k:int=0;k<Compiler.customActionList.length;k++){
								var ca:CustomAction=Compiler.customActionList[k];
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
					
					if(current){
						funList.push(getFunction(child));
					}else if(cElseIf!=null){
						cElseIf.funList.push(getFunction(child));
					}else{
						cElse.funList.push(getFunction(child));
					}
				}
			}
			if(cElseIf!=null){
				elseIfList.push(cElseIf);
			}
		}
		
		
		public function execute(child : XML,doc : SCXMLDocument,interpreter : IInterpreter):Function{
			var cond : Function = null;
			if(child.hasOwnProperty("@cond")) cond = getExprFunction(child.@cond,doc);
			parseIf(child,doc,interpreter);
			var f : Function = function() : void {
				//Enter if condition
				if(conditionMatch(cond)){
					for(var i:int = 0;i<funList.length;i++){
						var eachFun:Function = funList[i];
						eachFun.call();
					}
				}else{
					//Enter some elseif condition
					var exeFlag:Boolean = false;
					for(var i:int=0;i<elseIfList.length;i++){
						var elseIf:ElseIf=elseIfList[i];
						if(conditionMatch(elseIf.cond)){
							exeFlag=true;
							for(var j:int = 0;j<elseIf.funList.length;j++){
								var fun:Function = elseIf.funList[j];
								fun.call();
							}
						}
					}
					//Enter else condition
					if(!exeFlag){
						for(var j:int = 0;j<cElse.funList.length;j++){
							var elseFun:Function = cElse.funList[j];
							elseFun.call();
						}
					}
				}
			};
			return f;
		}
	}
}