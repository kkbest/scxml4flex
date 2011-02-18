package org.apache.commons.scxml.model.invoke {
	import org.apache.commons.scxml.datastructures.Queue;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.apache.commons.scxml.model.SCXML;
	
	import org.apache.commons.scxml.abstract.GenericState;
	import org.apache.commons.scxml.model.SCXMLDocument;
	import org.apache.commons.scxml.model.Compiler;
	import org.apache.commons.scxml.model.nodes.ElementContent;
	
	public class InvokeSCXML extends Invoke implements ElementContent{
		
		private var _invokeid : String;
		private var _type : String;
		private var sm : SCXML;
		private var loader : URLLoader;
		private var delayStartArgs : Array;
		
		public function InvokeSCXML() {
			sm = new SCXML();
		}
		
		public function loadFromSource(src : String) : void {
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, function(event : Event) : void {
				sm.source = XML(URLLoader(event.currentTarget).data);
				if(delayStartArgs) start.apply(null, delayStartArgs);
			});
			loader.load(new URLRequest(src));
		}
		
		public function set content(xml : XML) : void {
			sm.source = xml;
		}
		
		override public function send(eventName : Object, sendId : String = null, delay : Number = 0, data : Object = null, toQueue : Queue = null) : void {
			sm.send(eventName, sendId, delay, data, _invokeid, toQueue);
		}
		
		override public function start(optionalParentExternalQueue : Queue = null, invokeId : String = null) : void {
			if(!sm.source && loader)
				delayStartArgs = [optionalParentExternalQueue, invokeid];
			else {
				sm.start(optionalParentExternalQueue, invokeid);
//				super.start(optionalParentExternalQueue, invokeid);
			}
		} 
		public function compile(node:XML, parentState:GenericState, doc:SCXMLDocument, compiler:Compiler, i:int):void{
			var invoke : Invoke;
			switch(String(node.@type)) {
				case "scxml":
					var inv : InvokeSCXML =  new InvokeSCXML();
					if(node.hasOwnProperty("@src"))
						inv.loadFromSource(node.@src);
					else if(node.hasOwnProperty("content"))
						inv.content = XML(node.content.scxml.toString());
					if(node.hasOwnProperty("@autoforward") && node.@autoforward == "true")
						inv.autoforward = true;
					invoke = inv;
					break;
				default:
					invoke = new Invoke();
			}
			invoke.invokeid = node.@id;
			invoke.type = node.@type;
			parentState.addInvoke(invoke);
			if(node.hasOwnProperty("finalize") && XML(node.finalize).children().length() > 0) {
				invoke.finalizeArray = compiler.makeExecContent(XML(node.finalize));
			} else if(node.hasOwnProperty("finalize") && node.hasOwnProperty("param")) {
				var paramNodes : XMLList = node.(localName() == "param" && !hasOwnProperty("@expr"));
				
				invoke.finalizeArray = [
					function() : void {
						for each(var param : XML in paramNodes)
							doc.dataModel[String(param.@name)] = doc.dataModel["_event"].data[String(param.@name)];
							}
								];
			}
		}
		
	}
}