package scxml.invoke {
	import datastructures.Queue;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import interfaces.IInvoke;
	
	import scxml.SCXML;
	
	public class InvokeSCXML extends Invoke {
		
		private var _invokeid : String;
		private var _type : String;
		private var sm : SCXML;
		
		public function InvokeSCXML(src : String) {
			
			sm = new SCXML();
			
			var loader : URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, function(event : Event) : void {
				sm.source = URLLoader(event.currentTarget).data;
			});
			loader.load(new URLRequest(src));
			
		}
		
		override public function send(eventName : Object, sendId : String = null, delay : Number = 0, data : Object = null) : void {
			sm.send(eventName, sendId, delay, data);
		}
		
		override public function start(optionalParentExternalQueue : Queue = null, invokeId : String = null) : void {
			sm.start(optionalParentExternalQueue, invokeid);
		} 
		
	}
}