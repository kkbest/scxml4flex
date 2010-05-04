package scxml.invoke {
	import datastructures.Queue;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import scxml.SCXML;
	
	public class InvokeSCXML extends Invoke {
		
		private var _invokeid : String;
		private var _type : String;
		private var sm : SCXML;
		
		public function InvokeSCXML() {
			sm = new SCXML();
		}
		
		public function loadFromSource(src : String) : void {
			var loader : URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, function(event : Event) : void {
				sm.source = XML(URLLoader(event.currentTarget).data);
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
			sm.start(optionalParentExternalQueue, invokeid);
			super.start(optionalParentExternalQueue, invokeid);
		} 
		
	}
}